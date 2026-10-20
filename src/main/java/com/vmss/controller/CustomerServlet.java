package com.vmss.controller;

import com.vmss.model.Appointment;
import com.vmss.model.Invoice;
import com.vmss.model.User;
import com.vmss.model.Vehicle;
import com.vmss.service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/customer/*")
public class CustomerServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        User user = (User) req.getSession().getAttribute("currentUser");

        try {
            switch (pathInfo) {
                case "/dashboard":
                    handleDashboard(req, resp, user);
                    break;
                case "/profile":
                    req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, resp);
                    break;
                case "/vehicles":
                    handleVehiclesList(req, resp, user);
                    break;
                case "/vehicles/add":
                    req.getRequestDispatcher("/WEB-INF/views/customer/vehicle-form.jsp").forward(req, resp);
                    break;
                case "/vehicles/edit":
                    handleEditVehicle(req, resp, user);
                    break;
                case "/bookings":
                    handleBookingsList(req, resp, user);
                    break;
                case "/bookings/new":
                    handleNewBooking(req, resp, user);
                    break;
                case "/bookings/details":
                    handleBookingDetails(req, resp, user);
                    break;
                case "/service-history":
                    handleServiceHistory(req, resp, user);
                    break;
                case "/invoices":
                    handleInvoicesList(req, resp, user);
                    break;
                case "/invoices/details":
                    handleInvoiceDetails(req, resp, user);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        User user = (User) req.getSession().getAttribute("currentUser");

        try {
            switch (pathInfo) {
                case "/profile/update":
                    handleUpdateProfile(req, resp, user);
                    break;
                case "/profile/password":
                    handleChangePassword(req, resp, user);
                    break;
                case "/vehicles/add":
                    handleAddVehicle(req, resp, user);
                    break;
                case "/vehicles/update":
                    handleUpdateVehicle(req, resp, user);
                    break;
                case "/vehicles/delete":
                    handleDeleteVehicle(req, resp, user);
                    break;
                case "/bookings/create":
                    handleCreateBooking(req, resp, user);
                    break;
                case "/bookings/cancel":
                    handleCancelBooking(req, resp, user);
                    break;
                case "/invoices/pay":
                    handlePayInvoice(req, resp, user);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
            }
        } catch (Exception e) {
            HttpSession session = req.getSession();
            session.setAttribute("errorMessage", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        req.setAttribute("stats", vehicleService.getCustomerDashboardStats(user.getUserId()));
        req.setAttribute("vehicles", vehicleService.getCustomerVehicles(user.getUserId()));
        List<Appointment> appts = vehicleService.getCustomerAppointments(user.getUserId());
        req.setAttribute("recentAppointments", appts.size() > 5 ? appts.subList(0, 5) : appts);
        req.getRequestDispatcher("/WEB-INF/views/customer/dashboard.jsp").forward(req, resp);
    }

    private void handleVehiclesList(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        req.setAttribute("vehicles", vehicleService.getCustomerVehicles(user.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/customer/vehicles.jsp").forward(req, resp);
    }

    private void handleEditVehicle(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int vehicleId = Integer.parseInt(req.getParameter("id"));
        Vehicle v = vehicleService.getVehicleById(vehicleId);
        if (v == null || v.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }
        req.setAttribute("vehicle", v);
        req.getRequestDispatcher("/WEB-INF/views/customer/vehicle-form.jsp").forward(req, resp);
    }

    private void handleAddVehicle(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        String regNo = req.getParameter("registrationNo");
        String type = req.getParameter("vehicleType");
        String brand = req.getParameter("brand");
        String model = req.getParameter("model");
        int year = Integer.parseInt(req.getParameter("manufacturingYear"));
        String fuel = req.getParameter("fuelType");
        String chassis = req.getParameter("chassisNo");
        int odometer = Integer.parseInt(req.getParameter("odometerReading") != null && !req.getParameter("odometerReading").isEmpty() ? req.getParameter("odometerReading") : "0");

        try {
            vehicleService.addVehicle(user.getUserId(), regNo, type, brand, model, year, fuel, chassis, odometer);
            req.getSession().setAttribute("successMessage", "Vehicle " + regNo.toUpperCase() + " registered successfully!");
            resp.sendRedirect(req.getContextPath() + "/customer/vehicles");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/customer/vehicle-form.jsp").forward(req, resp);
        }
    }

    private void handleUpdateVehicle(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
        String type = req.getParameter("vehicleType");
        String brand = req.getParameter("brand");
        String model = req.getParameter("model");
        int year = Integer.parseInt(req.getParameter("manufacturingYear"));
        String fuel = req.getParameter("fuelType");
        String chassis = req.getParameter("chassisNo");
        int odometer = Integer.parseInt(req.getParameter("odometerReading") != null && !req.getParameter("odometerReading").isEmpty() ? req.getParameter("odometerReading") : "0");

        try {
            vehicleService.updateVehicle(user.getUserId(), vehicleId, type, brand, model, year, fuel, chassis, odometer);
            req.getSession().setAttribute("successMessage", "Vehicle details updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/customer/vehicles");
        } catch (Exception e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("vehicle", vehicleService.getVehicleById(vehicleId));
            req.getRequestDispatcher("/WEB-INF/views/customer/vehicle-form.jsp").forward(req, resp);
        }
    }

    private void handleDeleteVehicle(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
        try {
            vehicleService.deleteVehicle(user.getUserId(), vehicleId);
            req.getSession().setAttribute("successMessage", "Vehicle record removed successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/customer/vehicles");
    }

    private void handleBookingsList(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        req.setAttribute("appointments", vehicleService.getCustomerAppointments(user.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/customer/bookings.jsp").forward(req, resp);
    }

    private void handleNewBooking(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        List<Vehicle> vehicles = vehicleService.getCustomerVehicles(user.getUserId());
        if (vehicles.isEmpty()) {
            req.getSession().setAttribute("errorMessage", "Please register at least one vehicle before booking a service appointment.");
            resp.sendRedirect(req.getContextPath() + "/customer/vehicles/add");
            return;
        }
        req.setAttribute("vehicles", vehicles);
        req.setAttribute("services", vehicleService.getActiveServices());
        req.getRequestDispatcher("/WEB-INF/views/customer/book-appointment.jsp").forward(req, resp);
    }

    private void handleCreateBooking(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
        int serviceId = Integer.parseInt(req.getParameter("serviceId"));
        Date apptDate = Date.valueOf(req.getParameter("appointmentDate"));
        String timeSlot = req.getParameter("timeSlot");
        String issue = req.getParameter("issueDescription");

        try {
            vehicleService.bookAppointment(user.getUserId(), vehicleId, serviceId, apptDate, timeSlot, issue);
            req.getSession().setAttribute("successMessage", "Appointment booked successfully! Our service team will verify and confirm shortly.");
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/customer/bookings/new");
        }
    }

    private void handleBookingDetails(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("id"));
        Appointment appt = vehicleService.getAppointmentDetails(apptId);
        if (appt == null || appt.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }
        req.setAttribute("appointment", appt);
        req.setAttribute("timeline", vehicleService.getAppointmentTimeline(apptId));
        req.setAttribute("serviceRecord", vehicleService.getInvoiceByAppointmentId(apptId));
        req.getRequestDispatcher("/WEB-INF/views/customer/booking-details.jsp").forward(req, resp);
    }

    private void handleCancelBooking(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("appointmentId"));
        try {
            vehicleService.cancelAppointmentByCustomer(apptId, user.getUserId());
            req.getSession().setAttribute("successMessage", "Appointment #" + apptId + " was cancelled successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/customer/bookings");
    }

    private void handleServiceHistory(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        String vIdParam = req.getParameter("vehicleId");
        if (vIdParam != null && !vIdParam.trim().isEmpty()) {
            int vId = Integer.parseInt(vIdParam.trim());
            Vehicle v = vehicleService.getVehicleById(vId);
            if (v != null && v.getUserId() == user.getUserId()) {
                req.setAttribute("history", vehicleService.getVehicleServiceHistory(vId));
                req.setAttribute("selectedVehicle", v);
            } else {
                req.setAttribute("history", vehicleService.getCustomerServiceHistory(user.getUserId()));
            }
        } else {
            req.setAttribute("history", vehicleService.getCustomerServiceHistory(user.getUserId()));
        }
        req.getRequestDispatcher("/WEB-INF/views/customer/service-history.jsp").forward(req, resp);
    }

    private void handleInvoicesList(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        req.setAttribute("invoices", vehicleService.getCustomerInvoices(user.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/customer/invoices.jsp").forward(req, resp);
    }

    private void handleInvoiceDetails(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int invId = Integer.parseInt(req.getParameter("id"));
        Invoice inv = vehicleService.getInvoiceById(invId);
        if (inv == null || inv.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }
        req.setAttribute("invoice", inv);
        req.setAttribute("payments", vehicleService.getPaymentsForInvoice(invId));
        req.getRequestDispatcher("/WEB-INF/views/customer/invoice-details.jsp").forward(req, resp);
    }

    private void handlePayInvoice(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        int invId = Integer.parseInt(req.getParameter("invoiceId"));
        Invoice inv = vehicleService.getInvoiceById(invId);
        if (inv == null || inv.getUserId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }

        String method = req.getParameter("paymentMethod");
        String reference = req.getParameter("paymentReference");

        vehicleService.recordPayment(invId, inv.getTotalAmount(), method, reference);
        req.getSession().setAttribute("successMessage", "Payment simulated successfully! Invoice is marked as PAID.");
        resp.sendRedirect(req.getContextPath() + "/customer/invoices/details?id=" + invId);
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        String name = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        vehicleService.updateProfile(user.getUserId(), name, phone);
        user.setFullName(name);
        user.setPhone(phone);
        req.getSession().setAttribute("currentUser", user);
        req.getSession().setAttribute("successMessage", "Profile updated successfully!");
        resp.sendRedirect(req.getContextPath() + "/customer/profile");
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User user) throws Exception {
        String current = req.getParameter("currentPassword");
        String next = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        if (next == null || !next.equals(confirm)) {
            req.getSession().setAttribute("errorMessage", "New passwords do not match.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile");
            return;
        }

        try {
            vehicleService.changePassword(user.getUserId(), current, next);
            req.getSession().setAttribute("successMessage", "Password changed successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/customer/profile");
    }
}
