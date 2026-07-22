package com.project.dto.ai;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnalyzeRequest {

    private String incidentId;

    private String description;

    private String incidentType;

    private Double latitude;

    private Double longitude;

    private List<String> mediaUrls;

    private String analysisType;
}