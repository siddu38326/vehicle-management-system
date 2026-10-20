package com.vmss.controller;

import com.vmss.model.Appointment;
import com.vmss.model.Invoice;
import com.vmss.model.ServiceType;
import com.vmss.model.User;
import com.vmss.service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    handleDashboard(req, resp);
                    break;
                case "/customers":
                    req.setAttribute("customers", vehicleService.getAllCustomers());
                    req.getRequestDispatcher("/WEB-INF/views/admin/customers.jsp").forward(req, resp);
                    break;
                case "/vehicles":
                    req.setAttribute("vehicles", vehicleService.getAllVehicles());
                    req.getRequestDispatcher("/WEB-INF/views/admin/vehicles.jsp").forward(req, resp);
                    break;
                case "/services":
                    req.setAttribute("services", vehicleService.getAllServices());
                    req.getRequestDispatcher("/WEB-INF/views/admin/services.jsp").forward(req, resp);
                    break;
                case "/appointments":
                    handleAppointmentsList(req, resp);
                    break;
                case "/appointments/details":
                    handleAppointmentDetails(req, resp);
                    break;
                case "/invoices":
                    req.setAttribute("invoices", vehicleService.getAllInvoices());
                    req.getRequestDispatcher("/WEB-INF/views/admin/invoices.jsp").forward(req, resp);
                    break;
                case "/invoices/details":
                    handleInvoiceDetails(req, resp);
                    break;
                case "/payments":
                    req.setAttribute("payments", vehicleService.getAllPayments());
                    req.getRequestDispatcher("/WEB-INF/views/admin/payments.jsp").forward(req, resp);
                    break;
                case "/reports":
                    handleReports(req, resp);
                    break;
                case "/profile":
                    req.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(req, resp);
                    break;
                case "/vehicles/history":
                    handleVehicleHistory(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Admin Error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        User admin = (User) req.getSession().getAttribute("currentUser");

        try {
            switch (pathInfo) {
                case "/services/create":
                    handleCreateService(req, resp);
                    break;
                case "/services/update":
                    handleUpdateService(req, resp);
                    break;
                case "/services/toggle":
                    handleToggleService(req, resp);
                    break;
                case "/appointments/update-status":
                    handleUpdateAppointmentStatus(req, resp, admin);
                    break;
                case "/appointments/add-progress":
                    handleAddProgress(req, resp, admin);
                    break;
                case "/invoices/generate":
                    handleGenerateInvoice(req, resp, admin);
                    break;
                case "/invoices/record-payment":
                    handleRecordPayment(req, resp);
                    break;
                case "/customers/toggle":
                    handleToggleCustomer(req, resp);
                    break;
                case "/profile/update":
                    handleUpdateProfile(req, resp, admin);
                    break;
                case "/profile/password":
                    handleChangePassword(req, resp, admin);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        req.setAttribute("stats", vehicleService.getAdminDashboardStats());
        List<Appointment> allAppts = vehicleService.getAllAppointments(null, null);
        req.setAttribute("recentAppointments", allAppts.size() > 5 ? allAppts.subList(0, 5) : allAppts);
        req.setAttribute("services", vehicleService.getActiveServices());
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void handleAppointmentsList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String status = req.getParameter("status");
        String q = req.getParameter("q");
        req.setAttribute("appointments", vehicleService.getAllAppointments(status, q));
        req.setAttribute("currentStatus", status != null ? status : "ALL");
        req.setAttribute("currentSearch", q != null ? q : "");
        req.getRequestDispatcher("/WEB-INF/views/admin/appointments.jsp").forward(req, resp);
    }

    private void handleAppointmentDetails(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("id"));
        Appointment appt = vehicleService.getAppointmentDetails(apptId);
        if (appt == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/appointments");
            return;
        }
        req.setAttribute("appointment", appt);
        req.setAttribute("timeline", vehicleService.getAppointmentTimeline(apptId));
        req.setAttribute("invoice", vehicleService.getInvoiceByAppointmentId(apptId));
        req.getRequestDispatcher("/WEB-INF/views/admin/appointment-details.jsp").forward(req, resp);
    }

    private void handleInvoiceDetails(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int invId = Integer.parseInt(req.getParameter("id"));
        Invoice inv = vehicleService.getInvoiceById(invId);
        if (inv == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/invoices");
            return;
        }
        req.setAttribute("invoice", inv);
        req.setAttribute("payments", vehicleService.getPaymentsForInvoice(invId));
        req.getRequestDispatcher("/WEB-INF/views/admin/invoice-details.jsp").forward(req, resp);
    }

    private void handleCreateService(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String name = req.getParameter("serviceName");
        String desc = req.getParameter("description");
        String vType = req.getParameter("vehicleType");
        BigDecimal price = new BigDecimal(req.getParameter("basePrice"));
        String duration = req.getParameter("estimatedDuration");

        vehicleService.createService(name, desc, vType, price, duration);
        req.getSession().setAttribute("successMessage", "New service added successfully!");
        resp.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleUpdateService(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("serviceId"));
        String name = req.getParameter("serviceName");
        String desc = req.getParameter("description");
        String vType = req.getParameter("vehicleType");
        BigDecimal price = new BigDecimal(req.getParameter("basePrice"));
        String duration = req.getParameter("estimatedDuration");
        boolean active = "true".equalsIgnoreCase(req.getParameter("active"));

        vehicleService.updateService(id, name, desc, vType, price, duration, active);
        req.getSession().setAttribute("successMessage", "Service updated successfully!");
        resp.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleToggleService(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("serviceId"));
        boolean active = Boolean.parseBoolean(req.getParameter("active"));
        vehicleService.toggleServiceStatus(id, active);
        req.getSession().setAttribute("successMessage", "Service status updated.");
        resp.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleUpdateAppointmentStatus(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("appointmentId"));
        String newStatus = req.getParameter("status");
        String remarks = req.getParameter("adminRemarks");

        vehicleService.updateAppointmentStatus(apptId, newStatus, remarks, admin.getUserId());
        req.getSession().setAttribute("successMessage", "Appointment #" + apptId + " status updated to " + newStatus);
        resp.sendRedirect(req.getContextPath() + "/admin/appointments/details?id=" + apptId);
    }

    private void handleAddProgress(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("appointmentId"));
        String stage = req.getParameter("stageStatus");
        String desc = req.getParameter("description");

        vehicleService.addServiceProgress(apptId, admin.getUserId(), stage, desc);
        req.getSession().setAttribute("successMessage", "Service stage updated to: " + stage);
        resp.sendRedirect(req.getContextPath() + "/admin/appointments/details?id=" + apptId);
    }

    private void handleGenerateInvoice(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        int apptId = Integer.parseInt(req.getParameter("appointmentId"));
        String workDesc = req.getParameter("workDescription");
        BigDecimal partsCost = new BigDecimal(req.getParameter("partsCost"));
        BigDecimal laborCost = new BigDecimal(req.getParameter("laborCost"));
        BigDecimal discount = new BigDecimal(req.getParameter("discount") != null && !req.getParameter("discount").isEmpty() ? req.getParameter("discount") : "0");
        String remarks = req.getParameter("remarks");

        Invoice inv = vehicleService.completeServiceAndGenerateInvoice(apptId, admin.getUserId(), workDesc, partsCost, laborCost, discount, remarks);
        req.getSession().setAttribute("successMessage", "Service completed and Invoice " + inv.getInvoiceNumber() + " generated!");
        resp.sendRedirect(req.getContextPath() + "/admin/invoices/details?id=" + inv.getInvoiceId());
    }

    private void handleRecordPayment(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int invId = Integer.parseInt(req.getParameter("invoiceId"));
        BigDecimal amount = new BigDecimal(req.getParameter("amount"));
        String method = req.getParameter("paymentMethod");
        String reference = req.getParameter("paymentReference");

        vehicleService.recordPayment(invId, amount, method, reference);
        req.getSession().setAttribute("successMessage", "Payment recorded successfully!");
        resp.sendRedirect(req.getContextPath() + "/admin/invoices/details?id=" + invId);
    }

    private void handleReports(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        java.util.Map<String, Object> stats = vehicleService.getAdminDashboardStats();
        req.setAttribute("stats", stats);
        req.setAttribute("invoices", vehicleService.getAllInvoices());
        req.setAttribute("payments", vehicleService.getAllPayments());

        // Pre-compute percentages here (String.format is invalid in JSP EL)
        int total = stats.containsKey("totalAppointments") ? (int) stats.get("totalAppointments") : 0;
        int completed = stats.containsKey("completedAppointments") ? (int) stats.get("completedAppointments") : 0;
        int inProgress = stats.containsKey("inProgressAppointments") ? (int) stats.get("inProgressAppointments") : 0;
        int pending = stats.containsKey("pendingAppointments") ? (int) stats.get("pendingAppointments") : 0;
        int cancelled = stats.containsKey("cancelledAppointments") ? (int) stats.get("cancelledAppointments") : 0;

        if (total > 0) {
            req.setAttribute("conversionRate", String.format("%.1f", (completed * 100.0) / total));
            req.setAttribute("completedPct", String.format("%.0f", (completed * 100.0) / total));
            req.setAttribute("inProgressPct", String.format("%.0f", (inProgress * 100.0) / total));
            req.setAttribute("pendingPct", String.format("%.0f", (pending * 100.0) / total));
            req.setAttribute("cancelledPct", String.format("%.0f", (cancelled * 100.0) / total));
            req.setAttribute("completedWidth", (completed * 100.0) / total);
            req.setAttribute("inProgressWidth", (inProgress * 100.0) / total);
            req.setAttribute("pendingWidth", (pending * 100.0) / total);
            req.setAttribute("cancelledWidth", (cancelled * 100.0) / total);
        } else {
            req.setAttribute("conversionRate", "0.0");
            req.setAttribute("completedPct", "0");
            req.setAttribute("inProgressPct", "0");
            req.setAttribute("pendingPct", "0");
            req.setAttribute("cancelledPct", "0");
            req.setAttribute("completedWidth", 0.0);
            req.setAttribute("inProgressWidth", 0.0);
            req.setAttribute("pendingWidth", 0.0);
            req.setAttribute("cancelledWidth", 0.0);
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }

    private void handleToggleCustomer(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int userId = Integer.parseInt(req.getParameter("userId"));
        boolean active = Boolean.parseBoolean(req.getParameter("active"));
        vehicleService.toggleUserStatus(userId, active);
        req.getSession().setAttribute("successMessage", "Customer account status updated.");
        resp.sendRedirect(req.getContextPath() + "/admin/customers");
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        String name = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        vehicleService.updateProfile(admin.getUserId(), name, phone);
        admin.setFullName(name);
        admin.setPhone(phone);
        req.getSession().setAttribute("currentUser", admin);
        req.getSession().setAttribute("successMessage", "Admin profile updated successfully!");
        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User admin) throws Exception {
        String current = req.getParameter("currentPassword");
        String next = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        if (next == null || !next.equals(confirm)) {
            req.getSession().setAttribute("errorMessage", "New passwords do not match.");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        try {
            vehicleService.changePassword(admin.getUserId(), current, next);
            req.getSession().setAttribute("successMessage", "Administrator password changed successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    private void handleVehicleHistory(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int vehicleId = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("vehicle", vehicleService.getVehicleById(vehicleId));
        req.setAttribute("history", vehicleService.getVehicleServiceHistory(vehicleId));
        req.getRequestDispatcher("/WEB-INF/views/admin/vehicle-history.jsp").forward(req, resp);
    }
}
