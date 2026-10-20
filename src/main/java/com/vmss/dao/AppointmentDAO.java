package com.vmss.dao;

import com.vmss.model.Appointment;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public Appointment findById(int appointmentId) throws SQLException {
        String sql = "SELECT a.appointment_id, a.user_id, a.vehicle_id, a.service_id, a.appointment_date, a.time_slot, " +
                     "a.issue_description, a.estimated_cost, a.status, a.admin_remarks, a.created_at, a.updated_at, " +
                     "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, v.vehicle_type, " +
                     "s.service_name " +
                     "FROM appointments a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "WHERE a.appointment_id = ?";
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

    public List<Appointment> findByUserId(int userId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.user_id, a.vehicle_id, a.service_id, a.appointment_date, a.time_slot, " +
                     "a.issue_description, a.estimated_cost, a.status, a.admin_remarks, a.created_at, a.updated_at, " +
                     "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, v.vehicle_type, " +
                     "s.service_name " +
                     "FROM appointments a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "WHERE a.user_id = ? ORDER BY a.appointment_date DESC, a.created_at DESC";
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

    public List<Appointment> findAll(String statusFilter, String searchKeyword) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT a.appointment_id, a.user_id, a.vehicle_id, a.service_id, a.appointment_date, a.time_slot, ")
          .append("a.issue_description, a.estimated_cost, a.status, a.admin_remarks, a.created_at, a.updated_at, ")
          .append("u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, ")
          .append("v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, v.vehicle_type, ")
          .append("s.service_name ")
          .append("FROM appointments a ")
          .append("JOIN users u ON a.user_id = u.user_id ")
          .append("JOIN vehicles v ON a.vehicle_id = v.vehicle_id ")
          .append("JOIN services s ON a.service_id = s.service_id ")
          .append("WHERE 1=1 ");

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sb.append("AND a.status = ? ");
        }
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sb.append("AND (LOWER(u.full_name) LIKE ? OR LOWER(v.registration_no) LIKE ? OR LOWER(s.service_name) LIKE ?) ");
        }
        sb.append("ORDER BY a.appointment_date DESC, a.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            int paramIndex = 1;
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(paramIndex++, statusFilter.trim());
            }
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String pattern = "%" + searchKeyword.trim().toLowerCase() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public boolean create(Appointment appt) throws SQLException {
        String sql = "INSERT INTO appointments (user_id, vehicle_id, service_id, appointment_date, time_slot, issue_description, estimated_cost, status, admin_remarks) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, appt.getUserId());
            ps.setInt(2, appt.getVehicleId());
            ps.setInt(3, appt.getServiceId());
            ps.setDate(4, appt.getAppointmentDate());
            ps.setString(5, appt.getTimeSlot());
            ps.setString(6, appt.getIssueDescription());
            ps.setBigDecimal(7, appt.getEstimatedCost());
            ps.setString(8, appt.getStatus() != null ? appt.getStatus() : "PENDING");
            ps.setString(9, appt.getAdminRemarks());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        appt.setAppointmentId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean updateStatus(int appointmentId, String newStatus, String adminRemarks) throws SQLException {
        String sql = "UPDATE appointments SET status = ?, admin_remarks = ? WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, adminRemarks);
            ps.setInt(3, appointmentId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean cancelByCustomer(int appointmentId, int userId) throws SQLException {
        String sql = "UPDATE appointments SET status = 'CANCELLED' WHERE appointment_id = ? AND user_id = ? AND status IN ('PENDING', 'CONFIRMED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isSlotBooked(Date date, String timeSlot) throws SQLException {
        // We limit active bookings per slot to a configurable threshold, e.g., 3 active appointments per slot
        String sql = "SELECT COUNT(*) FROM appointments WHERE appointment_date = ? AND time_slot = ? AND status NOT IN ('CANCELLED', 'REJECTED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setString(2, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) >= 3; // slot capacity of 3
                }
            }
        }
        return false;
    }

    public int countByStatus(String status) throws SQLException {
        String sql = status == null ? "SELECT COUNT(*) FROM appointments" : "SELECT COUNT(*) FROM appointments WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (status != null) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countByUserIdAndStatus(int userId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments WHERE user_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private Appointment mapRow(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setUserId(rs.getInt("user_id"));
        a.setVehicleId(rs.getInt("vehicle_id"));
        a.setServiceId(rs.getInt("service_id"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setTimeSlot(rs.getString("time_slot"));
        a.setIssueDescription(rs.getString("issue_description"));
        a.setEstimatedCost(rs.getBigDecimal("estimated_cost"));
        a.setStatus(rs.getString("status"));
        a.setAdminRemarks(rs.getString("admin_remarks"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));

        a.setCustomerName(rs.getString("customer_name"));
        a.setCustomerEmail(rs.getString("customer_email"));
        a.setCustomerPhone(rs.getString("customer_phone"));
        a.setVehicleRegNo(rs.getString("vehicle_reg_no"));
        a.setVehicleBrand(rs.getString("vehicle_brand"));
        a.setVehicleModel(rs.getString("vehicle_model"));
        a.setVehicleType(rs.getString("vehicle_type"));
        a.setServiceName(rs.getString("service_name"));
        return a;
    }
}
