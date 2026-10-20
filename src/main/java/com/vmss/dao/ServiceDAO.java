package com.vmss.dao;

import com.vmss.model.ServiceType;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public ServiceType findById(int serviceId) throws SQLException {
        String sql = "SELECT service_id, service_name, description, vehicle_type, base_price, estimated_duration, active, created_at " +
                     "FROM services WHERE service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<ServiceType> findAll() throws SQLException {
        List<ServiceType> list = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, vehicle_type, base_price, estimated_duration, active, created_at " +
                     "FROM services ORDER BY active DESC, service_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<ServiceType> findActiveServices() throws SQLException {
        List<ServiceType> list = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, vehicle_type, base_price, estimated_duration, active, created_at " +
                     "FROM services WHERE active = TRUE ORDER BY service_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<ServiceType> findActiveForVehicleType(String vehicleType) throws SQLException {
        List<ServiceType> list = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, vehicle_type, base_price, estimated_duration, active, created_at " +
                     "FROM services WHERE active = TRUE AND (vehicle_type = 'All' OR vehicle_type = ?) ORDER BY service_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicleType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public boolean create(ServiceType service) throws SQLException {
        String sql = "INSERT INTO services (service_name, description, vehicle_type, base_price, estimated_duration, active) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setString(3, service.getVehicleType());
            ps.setBigDecimal(4, service.getBasePrice());
            ps.setString(5, service.getEstimatedDuration());
            ps.setBoolean(6, service.isActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        service.setServiceId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean update(ServiceType service) throws SQLException {
        String sql = "UPDATE services SET service_name = ?, description = ?, vehicle_type = ?, base_price = ?, estimated_duration = ?, active = ? " +
                     "WHERE service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setString(3, service.getVehicleType());
            ps.setBigDecimal(4, service.getBasePrice());
            ps.setString(5, service.getEstimatedDuration());
            ps.setBoolean(6, service.isActive());
            ps.setInt(7, service.getServiceId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean setActive(int serviceId, boolean active) throws SQLException {
        String sql = "UPDATE services SET active = ? WHERE service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        }
    }

    private ServiceType mapRow(ResultSet rs) throws SQLException {
        ServiceType s = new ServiceType();
        s.setServiceId(rs.getInt("service_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setDescription(rs.getString("description"));
        s.setVehicleType(rs.getString("vehicle_type"));
        s.setBasePrice(rs.getBigDecimal("base_price"));
        s.setEstimatedDuration(rs.getString("estimated_duration"));
        s.setActive(rs.getBoolean("active"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
