package com.project.dto.incident;

import java.util.List;

public class IncidentReportResponse {

    private String incidentId;
    private List<String> imageUrls;

    public IncidentReportResponse() {}

    public IncidentReportResponse(String incidentId, List<String> imageUrls) {
        this.incidentId = incidentId;
        this.imageUrls = imageUrls;
    }

    public String getIncidentId() {
        return incidentId;
    }

    public void setIncidentId(String incidentId) {
        this.incidentId = incidentId;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
}