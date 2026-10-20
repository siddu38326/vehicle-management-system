package com.vmss.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Appointment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int appointmentId;
    private int userId;
    private int vehicleId;
    private int serviceId;
    private Date appointmentDate;
    private String timeSlot;
    private String issueDescription;
    private BigDecimal estimatedCost;
    private String status; // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED, REJECTED
    private String adminRemarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined presentation fields
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String vehicleRegNo;
    private String vehicleBrand;
    private String vehicleModel;
    private String vehicleType;
    private String serviceName;

    public Appointment() {}

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getIssueDescription() { return issueDescription; }
    public void setIssueDescription(String issueDescription) { this.issueDescription = issueDescription; }

    public BigDecimal getEstimatedCost() { return estimatedCost; }
    public void setEstimatedCost(BigDecimal estimatedCost) { this.estimatedCost = estimatedCost; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminRemarks() { return adminRemarks; }
    public void setAdminRemarks(String adminRemarks) { this.adminRemarks = adminRemarks; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getVehicleRegNo() { return vehicleRegNo; }
    public void setVehicleRegNo(String vehicleRegNo) { this.vehicleRegNo = vehicleRegNo; }

    public String getVehicleBrand() { return vehicleBrand; }
    public void setVehicleBrand(String vehicleBrand) { this.vehicleBrand = vehicleBrand; }

    public String getVehicleModel() { return vehicleModel; }
    public void setVehicleModel(String vehicleModel) { this.vehicleModel = vehicleModel; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public boolean isCancellable() {
        return "PENDING".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status);
    }

    public String getBadgeClass() {
        if ("PENDING".equalsIgnoreCase(status)) return "bg-warning text-dark";
        if ("CONFIRMED".equalsIgnoreCase(status)) return "bg-primary";
        if ("IN_PROGRESS".equalsIgnoreCase(status)) return "bg-info text-dark";
        if ("COMPLETED".equalsIgnoreCase(status)) return "bg-success";
        if ("CANCELLED".equalsIgnoreCase(status)) return "bg-secondary";
        if ("REJECTED".equalsIgnoreCase(status)) return "bg-danger";
        return "bg-light text-dark";
    }
}
