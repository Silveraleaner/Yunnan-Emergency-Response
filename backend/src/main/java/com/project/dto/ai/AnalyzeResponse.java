package com.project.dto.ai;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnalyzeResponse {

    private String incidentId;

    private String analysisResult;

    private String severityLevel;

    private List<String> recommendations;

    private Map<String, Object> details;

    private String timestamp;
}