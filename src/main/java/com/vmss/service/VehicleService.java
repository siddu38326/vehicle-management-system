package com.vmss.service;

import com.vmss.dao.*;
import com.vmss.model.*;
import com.vmss.util.DBConnection;
import com.vmss.util.SecurityUtil;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

public class VehicleService {

    private final UserDAO userDAO = new UserDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final ServiceProgressDAO progressDAO = new ServiceProgressDAO();
    private final ServiceRecordDAO recordDAO = new ServiceRecordDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    // -------------------------------------------------------------
    // Authentication & User Management
    // -------------------------------------------------------------

    public User authenticate(String email, String plainPassword) throws SQLException {
        if (email == null || plainPassword == null) {
            return null;
        }
        User user = userDAO.findByEmail(email.trim());
        if (user != null && user.isActive()) {
            if (SecurityUtil.verifyPassword(plainPassword, user.getPasswordHash())) {
                return user;
            }
        }
        return null;
    }

    public boolean registerCustomer(String fullName, String email, String phone, String password) throws SQLException {
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || !email.contains("@") ||
            phone == null || phone.trim().length() < 10 ||
            password == null || password.length() < 6) {
            throw new IllegalArgumentException("Invalid registration inputs. Password must be at least 6 characters.");
        }

        if (userDAO.findByEmail(email.trim()) != null) {
            throw new IllegalArgumentException("An account with this email address already exists.");
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPhone(phone.trim());
        user.setPasswordHash(SecurityUtil.hashPassword(password));
        user.setRole("CUSTOMER");
        user.setActive(true);

        return userDAO.create(user);
    }

    public boolean updateProfile(int userId, String fullName, String phone) throws SQLException {
        return userDAO.updateProfile(userId, fullName, phone);
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) throws SQLException {
        User user = userDAO.findById(userId);
        if (user == null || !SecurityUtil.verifyPassword(oldPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Current password does not match.");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters.");
        }
        return userDAO.updatePassword(userId, SecurityUtil.hashPassword(newPassword));
    }

    public List<User> getAllCustomers() throws SQLException {
        return userDAO.findAllCustomers();
    }

    public boolean toggleUserStatus(int userId, boolean active) throws SQLException {
        return userDAO.updateStatus(userId, active);
    }

    // -------------------------------------------------------------
    // Vehicle Management
    // -------------------------------------------------------------

    public List<Vehicle> getCustomerVehicles(int userId) throws SQLException {
        return vehicleDAO.findByUserId(userId);
    }

    public Vehicle getVehicleById(int vehicleId) throws SQLException {
        return vehicleDAO.findById(vehicleId);
    }

    public List<Vehicle> getAllVehicles() throws SQLException {
        return vehicleDAO.findAll();
    }

    public boolean addVehicle(int userId, String regNo, String type, String brand, String model,
                              int year, String fuel, String chassis, int odometer) throws SQLException {
        if (regNo == null || regNo.trim().isEmpty() || brand == null || model == null) {
            throw new IllegalArgumentException("Vehicle registration number, brand, and model are required.");
        }
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        if (year < 1980 || year > currentYear + 1) {
            throw new IllegalArgumentException("Invalid manufacturing year.");
        }
        if (odometer < 0) {
            throw new IllegalArgumentException("Odometer reading cannot be negative.");
        }
        if (vehicleDAO.findByRegistrationNo(regNo.trim()) != null) {
            throw new IllegalArgumentException("Vehicle with registration number " + regNo.toUpperCase() + " is already registered.");
        }

        Vehicle v = new Vehicle();
        v.setUserId(userId);
        v.setRegistrationNo(regNo.trim().toUpperCase());
        v.setVehicleType(type);
        v.setBrand(brand.trim());
        v.setModel(model.trim());
        v.setManufacturingYear(year);
        v.setFuelType(fuel);
        v.setChassisNo(chassis != null ? chassis.trim().toUpperCase() : "");
        v.setOdometerReading(odometer);

        return vehicleDAO.create(v);
    }

    public boolean updateVehicle(int userId, int vehicleId, String type, String brand, String model,
                                 int year, String fuel, String chassis, int odometer) throws SQLException {
        Vehicle existing = vehicleDAO.findById(vehicleId);
        if (existing == null || existing.getUserId() != userId) {
            throw new SecurityException("Unauthorized access to vehicle record.");
        }
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        if (year < 1980 || year > currentYear + 1) {
            throw new IllegalArgumentException("Invalid manufacturing year.");
        }

        existing.setVehicleType(type);
        existing.setBrand(brand.trim());
        existing.setModel(model.trim());
        existing.setManufacturingYear(year);
        existing.setFuelType(fuel);
        existing.setChassisNo(chassis != null ? chassis.trim().toUpperCase() : "");
        existing.setOdometerReading(odometer);

        return vehicleDAO.update(existing);
    }

    public boolean deleteVehicle(int userId, int vehicleId) throws SQLException {
        Vehicle existing = vehicleDAO.findById(vehicleId);
        if (existing == null || existing.getUserId() != userId) {
            throw new SecurityException("Unauthorized access to vehicle record.");
        }
        if (vehicleDAO.hasAssociatedRecords(vehicleId)) {
            throw new IllegalStateException("Cannot delete vehicle because it has service history or active appointments. Retaining record for auditing.");
        }
        return vehicleDAO.delete(vehicleId, userId);
    }

    // -------------------------------------------------------------
    // Service Catalog
    // -------------------------------------------------------------

    public List<ServiceType> getAllServices() throws SQLException {
        return serviceDAO.findAll();
    }

    public List<ServiceType> getActiveServices() throws SQLException {
        return serviceDAO.findActiveServices();
    }

    public List<ServiceType> getActiveServicesForVehicle(String vehicleType) throws SQLException {
        return serviceDAO.findActiveForVehicleType(vehicleType);
    }

    public ServiceType getServiceById(int serviceId) throws SQLException {
        return serviceDAO.findById(serviceId);
    }

    public boolean createService(String name, String desc, String vType, BigDecimal price, String duration) throws SQLException {
        ServiceType s = new ServiceType();
        s.setServiceName(name.trim());
        s.setDescription(desc != null ? desc.trim() : "");
        s.setVehicleType(vType);
        s.setBasePrice(price != null ? price : BigDecimal.ZERO);
        s.setEstimatedDuration(duration != null ? duration.trim() : "1-2 hours");
        s.setActive(true);
        return serviceDAO.create(s);
    }

    public boolean updateService(int serviceId, String name, String desc, String vType, BigDecimal price, String duration, boolean active) throws SQLException {
        ServiceType s = serviceDAO.findById(serviceId);
        if (s == null) return false;
        s.setServiceName(name.trim());
        s.setDescription(desc != null ? desc.trim() : "");
        s.setVehicleType(vType);
        s.setBasePrice(price != null ? price : BigDecimal.ZERO);
        s.setEstimatedDuration(duration != null ? duration.trim() : "1-2 hours");
        s.setActive(active);
        return serviceDAO.update(s);
    }

    public boolean toggleServiceStatus(int serviceId, boolean active) throws SQLException {
        return serviceDAO.setActive(serviceId, active);
    }

    // -------------------------------------------------------------
    // Appointment Booking & Tracking
    // -------------------------------------------------------------

    public boolean bookAppointment(int userId, int vehicleId, int serviceId, Date date, String slot, String issue) throws SQLException {
        Vehicle vehicle = vehicleDAO.findById(vehicleId);
        if (vehicle == null || vehicle.getUserId() != userId) {
            throw new SecurityException("You can only book appointments for your own registered vehicles.");
        }
        ServiceType service = serviceDAO.findById(serviceId);
        if (service == null || !service.isActive()) {
            throw new IllegalArgumentException("Selected service is currently inactive or unavailable.");
        }
        Date today = new Date(System.currentTimeMillis());
        if (date.before(today)) {
            throw new IllegalArgumentException("Appointment date cannot be in the past.");
        }

        if (appointmentDAO.isSlotBooked(date, slot)) {
            throw new IllegalStateException("The selected time slot is fully booked for this date. Please choose another slot.");
        }

        Appointment appt = new Appointment();
        appt.setUserId(userId);
        appt.setVehicleId(vehicleId);
        appt.setServiceId(serviceId);
        appt.setAppointmentDate(date);
        appt.setTimeSlot(slot);
        appt.setIssueDescription(issue != null ? issue.trim() : "");
        appt.setEstimatedCost(service.getBasePrice());
        appt.setStatus("PENDING");
        appt.setAdminRemarks("Awaiting review from service center manager.");

        return appointmentDAO.create(appt);
    }

    public List<Appointment> getCustomerAppointments(int userId) throws SQLException {
        return appointmentDAO.findByUserId(userId);
    }

    public Appointment getAppointmentDetails(int appointmentId) throws SQLException {
        return appointmentDAO.findById(appointmentId);
    }

    public boolean cancelAppointmentByCustomer(int appointmentId, int userId) throws SQLException {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null || appt.getUserId() != userId) {
            throw new SecurityException("Unauthorized appointment cancellation.");
        }
        if (!appt.isCancellable()) {
            throw new IllegalStateException("Only PENDING or CONFIRMED appointments can be cancelled.");
        }
        return appointmentDAO.cancelByCustomer(appointmentId, userId);
    }

    public List<Appointment> getAllAppointments(String statusFilter, String searchKeyword) throws SQLException {
        return appointmentDAO.findAll(statusFilter, searchKeyword);
    }

    public boolean updateAppointmentStatus(int appointmentId, String newStatus, String adminRemarks, int adminId) throws SQLException {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Appointment not found.");
        }

        boolean updated = appointmentDAO.updateStatus(appointmentId, newStatus, adminRemarks);
        if (updated) {
            ServiceProgress progress = new ServiceProgress();
            progress.setAppointmentId(appointmentId);
            progress.setAdminId(adminId);
            progress.setStatus(newStatus);
            progress.setDescription("Status updated to " + newStatus + ". Remarks: " + (adminRemarks != null ? adminRemarks : ""));
            progressDAO.create(progress);
        }
        return updated;
    }

    public boolean addServiceProgress(int appointmentId, int adminId, String stageStatus, String description) throws SQLException {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) throw new IllegalArgumentException("Appointment not found");

        ServiceProgress sp = new ServiceProgress();
        sp.setAppointmentId(appointmentId);
        sp.setAdminId(adminId);
        sp.setStatus(stageStatus);
        sp.setDescription(description);

        boolean ok = progressDAO.create(sp);
        if (ok && "Work Completed".equalsIgnoreCase(stageStatus)) {
            appointmentDAO.updateStatus(appointmentId, "COMPLETED", "Service work finished and verified.");
        } else if (ok && "Vehicle Received".equalsIgnoreCase(stageStatus)) {
            appointmentDAO.updateStatus(appointmentId, "IN_PROGRESS", "Vehicle received at bay.");
        }
        return ok;
    }

    public List<ServiceProgress> getAppointmentTimeline(int appointmentId) throws SQLException {
        return progressDAO.findByAppointmentId(appointmentId);
    }

    // -------------------------------------------------------------
    // Service Completion & Invoicing (Transactional)
    // -------------------------------------------------------------

    public Invoice completeServiceAndGenerateInvoice(int appointmentId, int adminId, String workDesc,
                                                     BigDecimal partsCost, BigDecimal laborCost,
                                                     BigDecimal discount, String remarks) throws SQLException {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Appointment not found.");
        }

        // Use transaction across appointment status, service record, service progress, and invoice
        try (Connection conn = DBConnection.getConnection()) {
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                // 1. Update appointment status
                appointmentDAO.updateStatus(appointmentId, "COMPLETED", "Service completed by technician. Invoice generated.");

                // 2. Insert service record
                ServiceRecord sr = new ServiceRecord();
                sr.setAppointmentId(appointmentId);
                sr.setWorkDescription(workDesc);
                sr.setPartsCost(partsCost != null ? partsCost : BigDecimal.ZERO);
                sr.setLaborCost(laborCost != null ? laborCost : BigDecimal.ZERO);
                sr.setRemarks(remarks);
                sr.setCompletionDate(new Date(System.currentTimeMillis()));
                recordDAO.create(conn, sr);

                // 3. Calculate invoice financial figures with BigDecimal
                BigDecimal subtotal = sr.getTotalCost();
                BigDecimal disc = discount != null ? discount : BigDecimal.ZERO;
                BigDecimal taxable = subtotal.subtract(disc);
                if (taxable.compareTo(BigDecimal.ZERO) < 0) taxable = BigDecimal.ZERO;

                BigDecimal taxRate = new BigDecimal("18.00");
                BigDecimal taxAmount = taxable.multiply(taxRate).divide(new BigDecimal("100.00"), 2, RoundingMode.HALF_UP);
                BigDecimal totalAmount = taxable.add(taxAmount);

                // 4. Generate invoice number
                String invNum = "INV-" + new SimpleDateFormat("yyyyMM").format(new java.util.Date()) + "-" + String.format("%04d", appointmentId);

                Invoice inv = new Invoice();
                inv.setInvoiceNumber(invNum);
                inv.setAppointmentId(appointmentId);
                inv.setSubtotal(subtotal);
                inv.setDiscount(disc);
                inv.setTaxRate(taxRate);
                inv.setTaxAmount(taxAmount);
                inv.setTotalAmount(totalAmount);
                inv.setPaymentStatus("UNPAID");
                inv.setInvoiceDate(new Date(System.currentTimeMillis()));
                invoiceDAO.create(conn, inv);

                // 5. Add final progress entry
                ServiceProgress sp = new ServiceProgress();
                sp.setAppointmentId(appointmentId);
                sp.setAdminId(adminId);
                sp.setStatus("COMPLETED");
                sp.setDescription("Service completed. Final bill: ₹" + totalAmount.toString() + ". Ready for vehicle collection.");
                progressDAO.create(sp);

                conn.commit();
                return invoiceDAO.findById(inv.getInvoiceId());
            } catch (Exception ex) {
                conn.rollback();
                throw new SQLException("Transaction failed: " + ex.getMessage(), ex);
            } finally {
                conn.setAutoCommit(originalAutoCommit);
            }
        }
    }

    public boolean recordPayment(int invoiceId, BigDecimal amount, String method, String reference) throws SQLException {
        Invoice invoice = invoiceDAO.findById(invoiceId);
        if (invoice == null) {
            throw new IllegalArgumentException("Invoice not found.");
        }
        if ("PAID".equalsIgnoreCase(invoice.getPaymentStatus())) {
            throw new IllegalStateException("Invoice is already fully paid.");
        }

        try (Connection conn = DBConnection.getConnection()) {
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                PaymentRecord pr = new PaymentRecord();
                pr.setInvoiceId(invoiceId);
                pr.setAmount(amount != null ? amount : invoice.getTotalAmount());
                pr.setPaymentMethod(method != null ? method : "UPI");
                pr.setPaymentReference(reference != null && !reference.trim().isEmpty() ? reference : "SIM-" + System.currentTimeMillis());
                pr.setPaymentStatus("SUCCESS");
                paymentDAO.create(conn, pr);

                invoiceDAO.updatePaymentStatus(conn, invoiceId, "PAID");

                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                throw new SQLException("Failed to record payment: " + ex.getMessage(), ex);
            } finally {
                conn.setAutoCommit(originalAutoCommit);
            }
        }
    }

    public Invoice getInvoiceById(int invoiceId) throws SQLException {
        return invoiceDAO.findById(invoiceId);
    }

    public Invoice getInvoiceByAppointmentId(int appointmentId) throws SQLException {
        return invoiceDAO.findByAppointmentId(appointmentId);
    }

    public List<Invoice> getCustomerInvoices(int userId) throws SQLException {
        return invoiceDAO.findByUserId(userId);
    }

    public List<Invoice> getAllInvoices() throws SQLException {
        return invoiceDAO.findAll();
    }

    public List<ServiceRecord> getCustomerServiceHistory(int userId) throws SQLException {
        return recordDAO.findByUserId(userId);
    }

    public List<ServiceRecord> getVehicleServiceHistory(int vehicleId) throws SQLException {
        return recordDAO.findByVehicleId(vehicleId);
    }

    public List<PaymentRecord> getAllPayments() throws SQLException {
        return paymentDAO.findAll();
    }

    public List<PaymentRecord> getPaymentsForInvoice(int invoiceId) throws SQLException {
        return paymentDAO.findByInvoiceId(invoiceId);
    }

    // -------------------------------------------------------------
    // Dashboard Statistics
    // -------------------------------------------------------------

    public Map<String, Object> getAdminDashboardStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCustomers", userDAO.countCustomers());
        stats.put("totalVehicles", vehicleDAO.countVehicles());
        stats.put("totalAppointments", appointmentDAO.countByStatus(null));
        stats.put("pendingAppointments", appointmentDAO.countByStatus("PENDING"));
        stats.put("confirmedAppointments", appointmentDAO.countByStatus("CONFIRMED"));
        stats.put("inProgressAppointments", appointmentDAO.countByStatus("IN_PROGRESS"));
        stats.put("completedAppointments", appointmentDAO.countByStatus("COMPLETED"));
        stats.put("cancelledAppointments", appointmentDAO.countByStatus("CANCELLED"));
        stats.put("totalRevenue", invoiceDAO.calculateTotalRevenue());
        return stats;
    }

    public Map<String, Object> getCustomerDashboardStats(int userId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalVehicles", vehicleDAO.findByUserId(userId).size());
        stats.put("pendingAppointments", appointmentDAO.countByUserIdAndStatus(userId, "PENDING"));
        stats.put("confirmedAppointments", appointmentDAO.countByUserIdAndStatus(userId, "CONFIRMED"));
        stats.put("inProgressAppointments", appointmentDAO.countByUserIdAndStatus(userId, "IN_PROGRESS"));
        stats.put("completedAppointments", appointmentDAO.countByUserIdAndStatus(userId, "COMPLETED"));
        return stats;
    }
}
