package com.vmss.dao;

import com.vmss.model.Invoice;
import com.vmss.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    public Invoice findById(int invoiceId) throws SQLException {
        String sql = "SELECT i.invoice_id, i.invoice_number, i.appointment_id, i.subtotal, i.discount, i.tax_rate, " +
                     "i.tax_amount, i.total_amount, i.payment_status, i.invoice_date, i.created_at, " +
                     "a.user_id, u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "s.service_name, r.work_description, r.parts_cost, r.labor_cost " +
                     "FROM invoices i " +
                     "JOIN appointments a ON i.appointment_id = a.appointment_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN service_records r ON a.appointment_id = r.appointment_id " +
                     "WHERE i.invoice_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Invoice findByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT i.invoice_id, i.invoice_number, i.appointment_id, i.subtotal, i.discount, i.tax_rate, " +
                     "i.tax_amount, i.total_amount, i.payment_status, i.invoice_date, i.created_at, " +
                     "a.user_id, u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "s.service_name, r.work_description, r.parts_cost, r.labor_cost " +
                     "FROM invoices i " +
                     "JOIN appointments a ON i.appointment_id = a.appointment_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN service_records r ON a.appointment_id = r.appointment_id " +
                     "WHERE i.appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Invoice> findByUserId(int userId) throws SQLException {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.invoice_number, i.appointment_id, i.subtotal, i.discount, i.tax_rate, " +
                     "i.tax_amount, i.total_amount, i.payment_status, i.invoice_date, i.created_at, " +
                     "a.user_id, u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "s.service_name, r.work_description, r.parts_cost, r.labor_cost " +
                     "FROM invoices i " +
                     "JOIN appointments a ON i.appointment_id = a.appointment_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN service_records r ON a.appointment_id = r.appointment_id " +
                     "WHERE a.user_id = ? ORDER BY i.invoice_date DESC, i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<Invoice> findAll() throws SQLException {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.invoice_number, i.appointment_id, i.subtotal, i.discount, i.tax_rate, " +
                     "i.tax_amount, i.total_amount, i.payment_status, i.invoice_date, i.created_at, " +
                     "a.user_id, u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "s.service_name, r.work_description, r.parts_cost, r.labor_cost " +
                     "FROM invoices i " +
                     "JOIN appointments a ON i.appointment_id = a.appointment_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN service_records r ON a.appointment_id = r.appointment_id " +
                     "ORDER BY i.invoice_date DESC, i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public boolean create(Connection conn, Invoice inv) throws SQLException {
        String sql = "INSERT INTO invoices (invoice_number, appointment_id, subtotal, discount, tax_rate, tax_amount, total_amount, payment_status, invoice_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, inv.getInvoiceNumber());
            ps.setInt(2, inv.getAppointmentId());
            ps.setBigDecimal(3, inv.getSubtotal());
            ps.setBigDecimal(4, inv.getDiscount());
            ps.setBigDecimal(5, inv.getTaxRate());
            ps.setBigDecimal(6, inv.getTaxAmount());
            ps.setBigDecimal(7, inv.getTotalAmount());
            ps.setString(8, inv.getPaymentStatus());
            ps.setDate(9, inv.getInvoiceDate());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        inv.setInvoiceId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean updatePaymentStatus(Connection conn, int invoiceId, String status) throws SQLException {
        String sql = "UPDATE invoices SET payment_status = ? WHERE invoice_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, invoiceId);
            return ps.executeUpdate() > 0;
        }
    }

    public BigDecimal calculateTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices WHERE payment_status = 'PAID'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    private Invoice mapRow(ResultSet rs) throws SQLException {
        Invoice i = new Invoice();
        i.setInvoiceId(rs.getInt("invoice_id"));
        i.setInvoiceNumber(rs.getString("invoice_number"));
        i.setAppointmentId(rs.getInt("appointment_id"));
        i.setSubtotal(rs.getBigDecimal("subtotal"));
        i.setDiscount(rs.getBigDecimal("discount"));
        i.setTaxRate(rs.getBigDecimal("tax_rate"));
        i.setTaxAmount(rs.getBigDecimal("tax_amount"));
        i.setTotalAmount(rs.getBigDecimal("total_amount"));
        i.setPaymentStatus(rs.getString("payment_status"));
        i.setInvoiceDate(rs.getDate("invoice_date"));
        i.setCreatedAt(rs.getTimestamp("created_at"));

        i.setUserId(rs.getInt("user_id"));
        i.setCustomerName(rs.getString("customer_name"));
        i.setCustomerEmail(rs.getString("customer_email"));
        i.setCustomerPhone(rs.getString("customer_phone"));
        i.setVehicleRegNo(rs.getString("vehicle_reg_no"));
        i.setVehicleBrand(rs.getString("vehicle_brand"));
        i.setVehicleModel(rs.getString("vehicle_model"));
        i.setServiceName(rs.getString("service_name"));
        i.setPartsCost(rs.getBigDecimal("parts_cost"));
        i.setLaborCost(rs.getBigDecimal("labor_cost"));
        i.setWorkDescription(rs.getString("work_description"));
        return i;
    }
}
