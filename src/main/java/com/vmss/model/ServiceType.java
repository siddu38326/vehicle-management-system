package com.vmss.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class ServiceType implements Serializable {
    private static final long serialVersionUID = 1L;

    private int serviceId;
    private String serviceName;
    private String description;
    private String vehicleType; // "Two-Wheeler", "Four-Wheeler", "All"
    private BigDecimal basePrice;
    private String estimatedDuration;
    private boolean active;
    private Timestamp createdAt;

    public ServiceType() {}

    public ServiceType(int serviceId, String serviceName, String description, String vehicleType, BigDecimal basePrice, String estimatedDuration, boolean active, Timestamp createdAt) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.vehicleType = vehicleType;
        this.basePrice = basePrice;
        this.estimatedDuration = estimatedDuration;
        this.active = active;
        this.createdAt = createdAt;
    }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public String getEstimatedDuration() { return estimatedDuration; }
    public void setEstimatedDuration(String estimatedDuration) { this.estimatedDuration = estimatedDuration; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
