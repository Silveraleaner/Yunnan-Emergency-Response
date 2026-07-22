package com.project.dto.incident;

import com.project.dto.ai.EmergencyPlanDTO;

import java.time.LocalDateTime;

public class IncidentResponse {

    private String incidentId;
    private String title;
    private String description;
    private String incidentType;
    private String severity;
    private String status;
    private Double latitude;
    private Double longitude;
    private LocalDateTime reportTime;
    private LocalDateTime createdAt;
    private EmergencyPlanDTO emergencyPlan;

    public IncidentResponse() {}

    public String getIncidentId() {
        return incidentId;
    }

    public void setIncidentId(String incidentId) {
        this.incidentId = incidentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIncidentType() {
        return incidentType;
    }

    public void setIncidentType(String incidentType) {
        this.incidentType = incidentType;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public LocalDateTime getReportTime() {
        return reportTime;
    }

    public void setReportTime(LocalDateTime reportTime) {
        this.reportTime = reportTime;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public EmergencyPlanDTO getEmergencyPlan() {
        return emergencyPlan;
    }

    public void setEmergencyPlan(EmergencyPlanDTO emergencyPlan) {
        this.emergencyPlan = emergencyPlan;
    }
}