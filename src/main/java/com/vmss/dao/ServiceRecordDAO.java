package com.vmss.dao;

import com.vmss.model.ServiceRecord;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceRecordDAO {

    public ServiceRecord findByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT r.record_id, r.appointment_id, r.work_description, r.parts_cost, r.labor_cost, r.remarks, " +
                     "r.completion_date, r.created_at, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "u.full_name as customer_name, s.service_name " +
                     "FROM service_records r " +
                     "JOIN appointments a ON r.appointment_id = a.appointment_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "WHERE r.appointment_id = ?";
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

    public List<ServiceRecord> findByUserId(int userId) throws SQLException {
        List<ServiceRecord> list = new ArrayList<>();
        String sql = "SELECT r.record_id, r.appointment_id, r.work_description, r.parts_cost, r.labor_cost, r.remarks, " +
                     "r.completion_date, r.created_at, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "u.full_name as customer_name, s.service_name " +
                     "FROM service_records r " +
                     "JOIN appointments a ON r.appointment_id = a.appointment_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "WHERE a.user_id = ? ORDER BY r.completion_date DESC";
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

    public List<ServiceRecord> findByVehicleId(int vehicleId) throws SQLException {
        List<ServiceRecord> list = new ArrayList<>();
        String sql = "SELECT r.record_id, r.appointment_id, r.work_description, r.parts_cost, r.labor_cost, r.remarks, " +
                     "r.completion_date, r.created_at, " +
                     "v.registration_no as vehicle_reg_no, v.brand as vehicle_brand, v.model as vehicle_model, " +
                     "u.full_name as customer_name, s.service_name " +
                     "FROM service_records r " +
                     "JOIN appointments a ON r.appointment_id = a.appointment_id " +
                     "JOIN vehicles v ON a.vehicle_id = v.vehicle_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "JOIN services s ON a.service_id = s.service_id " +
                     "WHERE a.vehicle_id = ? ORDER BY r.completion_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public boolean create(Connection conn, ServiceRecord record) throws SQLException {
        String sql = "INSERT INTO service_records (appointment_id, work_description, parts_cost, labor_cost, remarks, completion_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, record.getAppointmentId());
            ps.setString(2, record.getWorkDescription());
            ps.setBigDecimal(3, record.getPartsCost());
            ps.setBigDecimal(4, record.getLaborCost());
            ps.setString(5, record.getRemarks());
            ps.setDate(6, record.getCompletionDate());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        record.setRecordId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    private ServiceRecord mapRow(ResultSet rs) throws SQLException {
        ServiceRecord sr = new ServiceRecord();
        sr.setRecordId(rs.getInt("record_id"));
        sr.setAppointmentId(rs.getInt("appointment_id"));
        sr.setWorkDescription(rs.getString("work_description"));
        sr.setPartsCost(rs.getBigDecimal("parts_cost"));
        sr.setLaborCost(rs.getBigDecimal("labor_cost"));
        sr.setRemarks(rs.getString("remarks"));
        sr.setCompletionDate(rs.getDate("completion_date"));
        sr.setCreatedAt(rs.getTimestamp("created_at"));
        sr.setVehicleRegNo(rs.getString("vehicle_reg_no"));
        sr.setVehicleBrand(rs.getString("vehicle_brand"));
        sr.setVehicleModel(rs.getString("vehicle_model"));
        sr.setCustomerName(rs.getString("customer_name"));
        sr.setServiceName(rs.getString("service_name"));
        return sr;
    }
}
