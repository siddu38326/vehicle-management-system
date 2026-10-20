package com.vmss.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Vehicle implements Serializable {
    private static final long serialVersionUID = 1L;

    private int vehicleId;
    private int userId;
    private String registrationNo;
    private String vehicleType; // "Two-Wheeler", "Four-Wheeler", "Other"
    private String brand;
    private String model;
    private int manufacturingYear;
    private String fuelType; // "Petrol", "Diesel", "Electric", "Hybrid", "CNG", "Other"
    private String chassisNo;
    private int odometerReading;
    private Timestamp createdAt;

    // Additional display field from joined user
    private String ownerName;
    private String ownerEmail;

    public Vehicle() {}

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRegistrationNo() { return registrationNo; }
    public void setRegistrationNo(String registrationNo) { this.registrationNo = registrationNo; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public int getManufacturingYear() { return manufacturingYear; }
    public void setManufacturingYear(int manufacturingYear) { this.manufacturingYear = manufacturingYear; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public String getChassisNo() { return chassisNo; }
    public void setChassisNo(String chassisNo) { this.chassisNo = chassisNo; }

    public int getOdometerReading() { return odometerReading; }
    public void setOdometerReading(int odometerReading) { this.odometerReading = odometerReading; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    public String getDisplayName() {
        return brand + " " + model + " (" + registrationNo + ")";
    }
}
