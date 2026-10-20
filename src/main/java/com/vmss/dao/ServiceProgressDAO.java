package com.vmss.dao;

import com.vmss.model.ServiceProgress;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceProgressDAO {

    public List<ServiceProgress> findByAppointmentId(int appointmentId) throws SQLException {
        List<ServiceProgress> list = new ArrayList<>();
        String sql = "SELECT p.progress_id, p.appointment_id, p.admin_id, p.status, p.description, p.created_at, " +
                     "u.full_name as admin_name " +
                     "FROM service_progress p " +
                     "JOIN users u ON p.admin_id = u.user_id " +
                     "WHERE p.appointment_id = ? ORDER BY p.created_at ASC, p.progress_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceProgress sp = new ServiceProgress();
                    sp.setProgressId(rs.getInt("progress_id"));
                    sp.setAppointmentId(rs.getInt("appointment_id"));
                    sp.setAdminId(rs.getInt("admin_id"));
                    sp.setStatus(rs.getString("status"));
                    sp.setDescription(rs.getString("description"));
                    sp.setCreatedAt(rs.getTimestamp("created_at"));
                    sp.setAdminName(rs.getString("admin_name"));
                    list.add(sp);
                }
            }
        }
        return list;
    }

    public boolean create(ServiceProgress progress) throws SQLException {
        String sql = "INSERT INTO service_progress (appointment_id, admin_id, status, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, progress.getAppointmentId());
            ps.setInt(2, progress.getAdminId());
            ps.setString(3, progress.getStatus());
            ps.setString(4, progress.getDescription());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        progress.setProgressId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }
}
