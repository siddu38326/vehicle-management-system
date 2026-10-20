package com.vmss;

import com.vmss.model.Appointment;
import com.vmss.model.Invoice;
import com.vmss.model.User;
import com.vmss.model.Vehicle;
import com.vmss.service.VehicleService;
import com.vmss.util.DBConnection;
import com.vmss.util.SecurityUtil;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class VmssComprehensiveTest {

    private static VehicleService service;

    @BeforeAll
    public static void setUp() {
        System.setProperty("DB_TYPE", "h2");
        DBConnection.initialize();
        service = new VehicleService();
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: BCrypt Password Hashing and Verification")
    public void testPasswordHashing() {
        String rawPassword = "TestPassword@123";
        String hash = SecurityUtil.hashPassword(rawPassword);

        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$") || hash.startsWith("$2b$"));
        assertTrue(SecurityUtil.verifyPassword(rawPassword, hash));
        assertFalse(SecurityUtil.verifyPassword("WrongPassword", hash));
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Authentication with Seeded Admin and Customer")
    public void testAuthentication() throws Exception {
        // Authenticate seeded admin
        User admin = service.authenticate("admin@vmss.com", "Admin@123");
        assertNotNull(admin, "Admin should authenticate with Admin@123");
        assertEquals("ADMIN", admin.getRole());
        assertTrue(admin.isAdmin());

        // Authenticate seeded customer
        User customer = service.authenticate("rahul@gmail.com", "Customer@123");
        assertNotNull(customer, "Customer should authenticate with Customer@123");
        assertEquals("CUSTOMER", customer.getRole());
        assertTrue(customer.isCustomer());

        // Authenticate with wrong password
        User invalid = service.authenticate("admin@vmss.com", "WrongPass");
        assertNull(invalid, "Invalid password should return null user");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Customer Registration and Duplicate Email Validation")
    public void testRegistrationAndValidation() throws Exception {
        String testEmail = "testuser" + System.currentTimeMillis() + "@gmail.com";
        boolean created = service.registerCustomer("Suresh Kumar", testEmail, "9988776655", "Pass@1234");
        assertTrue(created);

        // Attempt duplicate registration
        assertThrows(IllegalArgumentException.class, () -> {
            service.registerCustomer("Duplicate Person", testEmail, "9988776655", "Pass@1234");
        });
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Vehicle CRUD & Year/Odometer Validation")
    public void testVehicleCRUD() throws Exception {
        // Find existing customer id
        User customer = service.authenticate("rahul@gmail.com", "Customer@123");
        assertNotNull(customer);

        String regNo = "KA-05-TEST-" + (System.currentTimeMillis() % 10000);
        boolean added = service.addVehicle(customer.getUserId(), regNo, "Four-Wheeler", "Toyota", "Innova", 2022, "Diesel", "TOY1234567890", 25000);
        assertTrue(added);

        List<Vehicle> list = service.getCustomerVehicles(customer.getUserId());
        assertFalse(list.isEmpty());

        Vehicle addedVehicle = list.stream().filter(v -> regNo.equalsIgnoreCase(v.getRegistrationNo())).findFirst().orElse(null);
        assertNotNull(addedVehicle);

        // Test invalid year
        assertThrows(IllegalArgumentException.class, () -> {
            service.addVehicle(customer.getUserId(), "DL-01-FAIL-1", "Two-Wheeler", "Hero", "Splendor", 1970, "Petrol", "", 100);
        });

        // Test negative odometer
        assertThrows(IllegalArgumentException.class, () -> {
            service.addVehicle(customer.getUserId(), "DL-01-FAIL-2", "Two-Wheeler", "Hero", "Splendor", 2020, "Petrol", "", -50);
        });
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Vehicle Ownership Security Checks")
    public void testOwnershipProtection() throws Exception {
        User customer1 = service.authenticate("rahul@gmail.com", "Customer@123");
        User customer2 = service.authenticate("priya@gmail.com", "Customer@123");

        List<Vehicle> customer2Vehicles = service.getCustomerVehicles(customer2.getUserId());
        assertFalse(customer2Vehicles.isEmpty());
        int c2VehicleId = customer2Vehicles.get(0).getVehicleId();

        // Customer 1 trying to edit or delete Customer 2's vehicle
        assertThrows(SecurityException.class, () -> {
            service.updateVehicle(customer1.getUserId(), c2VehicleId, "Four-Wheeler", "Hacked", "Vehicle", 2022, "Petrol", "", 0);
        });

        assertThrows(SecurityException.class, () -> {
            service.deleteVehicle(customer1.getUserId(), c2VehicleId);
        });
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Appointment Booking with Conflict and Past Date Checks")
    public void testAppointmentBooking() throws Exception {
        User customer = service.authenticate("rahul@gmail.com", "Customer@123");
        List<Vehicle> vehicles = service.getCustomerVehicles(customer.getUserId());
        assertFalse(vehicles.isEmpty());
        int vehicleId = vehicles.get(0).getVehicleId();

        Date tomorrow = new Date(System.currentTimeMillis() + 86400000L);
        Date past = new Date(System.currentTimeMillis() - 86400000L);

        // Past date booking should fail
        assertThrows(IllegalArgumentException.class, () -> {
            service.bookAppointment(customer.getUserId(), vehicleId, 1, past, "10:00 AM - 12:00 PM", "Past booking");
        });

        // Valid booking
        boolean booked = service.bookAppointment(customer.getUserId(), vehicleId, 1, tomorrow, "11:00 AM - 01:00 PM", "Brake testing");
        assertTrue(booked);
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Service Progress Milestones & Chronology")
    public void testServiceProgressTimeline() throws Exception {
        User admin = service.authenticate("admin@vmss.com", "Admin@123");
        assertNotNull(admin);

        List<Appointment> all = service.getAllAppointments(null, null);
        assertFalse(all.isEmpty());
        int apptId = all.get(0).getAppointmentId();

        boolean progressAdded = service.addServiceProgress(apptId, admin.getUserId(), "Inspection Started", "Underbody chassis inspection initiated.");
        assertTrue(progressAdded);

        assertFalse(service.getAppointmentTimeline(apptId).isEmpty());
    }

    @Test
    @Order(8)
    @DisplayName("Test 8: Financial Invoicing, GST Calculation & Simulation Payments")
    public void testInvoicingAndPayments() throws Exception {
        User admin = service.authenticate("admin@vmss.com", "Admin@123");
        User customer = service.authenticate("priya@gmail.com", "Customer@123");

        List<Vehicle> vehicles = service.getCustomerVehicles(customer.getUserId());
        Date date = new Date(System.currentTimeMillis() + 86400000L * 3);
        service.bookAppointment(customer.getUserId(), vehicles.get(0).getVehicleId(), 1, date, "04:00 PM - 06:00 PM", "Complete overhaul");

        List<Appointment> appts = service.getCustomerAppointments(customer.getUserId());
        int testApptId = appts.get(0).getAppointmentId();

        // Complete service and generate invoice
        // Parts: 1000.00, Labor: 500.00, Subtotal: 1500.00. Discount: 100.00 -> Taxable: 1400.00. Tax (18%): 252.00. Total: 1652.00
        Invoice invoice = service.completeServiceAndGenerateInvoice(testApptId, admin.getUserId(),
                "Replaced engine air filter, spark plugs, and synthetic engine oil",
                new BigDecimal("1000.00"), new BigDecimal("500.00"), new BigDecimal("100.00"), "Recommended wheel balancing next visit.");

        assertNotNull(invoice);
        assertEquals(new BigDecimal("1500.00"), invoice.getSubtotal());
        assertEquals(new BigDecimal("100.00"), invoice.getDiscount());
        assertEquals(new BigDecimal("252.00"), invoice.getTaxAmount());
        assertEquals(new BigDecimal("1652.00"), invoice.getTotalAmount());
        assertEquals("UNPAID", invoice.getPaymentStatus());

        // Simulate payment
        boolean paid = service.recordPayment(invoice.getInvoiceId(), invoice.getTotalAmount(), "UPI", "UPI-TEST-CONFIRM-12345");
        assertTrue(paid);

        Invoice updatedInvoice = service.getInvoiceById(invoice.getInvoiceId());
        assertEquals("PAID", updatedInvoice.getPaymentStatus());
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Live Dashboard Statistics Query Verification")
    public void testDashboardStats() throws Exception {
        Map<String, Object> adminStats = service.getAdminDashboardStats();
        assertNotNull(adminStats);
        assertTrue((Integer) adminStats.get("totalCustomers") > 0);
        assertTrue((Integer) adminStats.get("totalVehicles") > 0);
        assertTrue((Integer) adminStats.get("totalAppointments") > 0);
        assertNotNull(adminStats.get("totalRevenue"));
    }
}
