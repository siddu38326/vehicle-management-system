package com.vmss.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ServiceProgress implements Serializable {
    private static final long serialVersionUID = 1L;

    private int progressId;
    private int appointmentId;
    private int adminId;
    private String status;
    private String description;
    private Timestamp createdAt;

    // Joined admin name
    private String adminName;

    public ServiceProgress() {}

    public ServiceProgress(int progressId, int appointmentId, int adminId, String status, String description, Timestamp createdAt) {
        this.progressId = progressId;
        this.appointmentId = appointmentId;
        this.adminId = adminId;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getProgressId() { return progressId; }
    public void setProgressId(int progressId) { this.progressId = progressId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }
}
