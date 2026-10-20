package com.vmss.dao;

import com.vmss.model.Vehicle;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public Vehicle findById(int vehicleId) throws SQLException {
        String sql = "SELECT v.vehicle_id, v.user_id, v.registration_no, v.vehicle_type, v.brand, v.model, " +
                     "v.manufacturing_year, v.fuel_type, v.chassis_no, v.odometer_reading, v.created_at, " +
                     "u.full_name as owner_name, u.email as owner_email " +
                     "FROM vehicles v JOIN users u ON v.user_id = u.user_id WHERE v.vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Vehicle findByRegistrationNo(String regNo) throws SQLException {
        String sql = "SELECT v.vehicle_id, v.user_id, v.registration_no, v.vehicle_type, v.brand, v.model, " +
                     "v.manufacturing_year, v.fuel_type, v.chassis_no, v.odometer_reading, v.created_at, " +
                     "u.full_name as owner_name, u.email as owner_email " +
                     "FROM vehicles v JOIN users u ON v.user_id = u.user_id WHERE UPPER(v.registration_no) = UPPER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, regNo != null ? regNo.trim() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Vehicle> findByUserId(int userId) throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.vehicle_id, v.user_id, v.registration_no, v.vehicle_type, v.brand, v.model, " +
                     "v.manufacturing_year, v.fuel_type, v.chassis_no, v.odometer_reading, v.created_at, " +
                     "u.full_name as owner_name, u.email as owner_email " +
                     "FROM vehicles v JOIN users u ON v.user_id = u.user_id WHERE v.user_id = ? ORDER BY v.created_at DESC";
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

    public List<Vehicle> findAll() throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT v.vehicle_id, v.user_id, v.registration_no, v.vehicle_type, v.brand, v.model, " +
                     "v.manufacturing_year, v.fuel_type, v.chassis_no, v.odometer_reading, v.created_at, " +
                     "u.full_name as owner_name, u.email as owner_email " +
                     "FROM vehicles v JOIN users u ON v.user_id = u.user_id ORDER BY v.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public boolean create(Vehicle vehicle) throws SQLException {
        String sql = "INSERT INTO vehicles (user_id, registration_no, vehicle_type, brand, model, manufacturing_year, fuel_type, chassis_no, odometer_reading) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, vehicle.getUserId());
            ps.setString(2, vehicle.getRegistrationNo().toUpperCase());
            ps.setString(3, vehicle.getVehicleType());
            ps.setString(4, vehicle.getBrand());
            ps.setString(5, vehicle.getModel());
            ps.setInt(6, vehicle.getManufacturingYear());
            ps.setString(7, vehicle.getFuelType());
            ps.setString(8, vehicle.getChassisNo());
            ps.setInt(9, vehicle.getOdometerReading());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        vehicle.setVehicleId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean update(Vehicle vehicle) throws SQLException {
        String sql = "UPDATE vehicles SET vehicle_type = ?, brand = ?, model = ?, manufacturing_year = ?, fuel_type = ?, chassis_no = ?, odometer_reading = ? " +
                     "WHERE vehicle_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicle.getVehicleType());
            ps.setString(2, vehicle.getBrand());
            ps.setString(3, vehicle.getModel());
            ps.setInt(4, vehicle.getManufacturingYear());
            ps.setString(5, vehicle.getFuelType());
            ps.setString(6, vehicle.getChassisNo());
            ps.setInt(7, vehicle.getOdometerReading());
            ps.setInt(8, vehicle.getVehicleId());
            ps.setInt(9, vehicle.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int vehicleId, int userId) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE vehicle_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean hasAssociatedRecords(int vehicleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments WHERE vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int countVehicles() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Vehicle mapRow(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleId(rs.getInt("vehicle_id"));
        v.setUserId(rs.getInt("user_id"));
        v.setRegistrationNo(rs.getString("registration_no"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setBrand(rs.getString("brand"));
        v.setModel(rs.getString("model"));
        v.setManufacturingYear(rs.getInt("manufacturing_year"));
        v.setFuelType(rs.getString("fuel_type"));
        v.setChassisNo(rs.getString("chassis_no"));
        v.setOdometerReading(rs.getInt("odometer_reading"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            v.setOwnerName(rs.getString("owner_name"));
            v.setOwnerEmail(rs.getString("owner_email"));
        } catch (SQLException ignored) {}
        return v;
    }
}
