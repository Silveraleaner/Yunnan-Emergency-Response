package com.project.dto.ai;

import java.util.List;

public class EmergencyPlanDTO {

    private String responseLevel;
    private String estimatedImpact;
    private String recommendedResources;
    private List<String> actionSteps;

    public EmergencyPlanDTO() {}

    public EmergencyPlanDTO(String responseLevel, String estimatedImpact, String recommendedResources, List<String> actionSteps) {
        this.responseLevel = responseLevel;
        this.estimatedImpact = estimatedImpact;
        this.recommendedResources = recommendedResources;
        this.actionSteps = actionSteps;
    }

    public String getResponseLevel() {
        return responseLevel;
    }

    public void setResponseLevel(String responseLevel) {
        this.responseLevel = responseLevel;
    }

    public String getEstimatedImpact() {
        return estimatedImpact;
    }

    public void setEstimatedImpact(String estimatedImpact) {
        this.estimatedImpact = estimatedImpact;
    }

    public String getRecommendedResources() {
        return recommendedResources;
    }

    public void setRecommendedResources(String recommendedResources) {
        this.recommendedResources = recommendedResources;
    }

    public List<String> getActionSteps() {
        return actionSteps;
    }

    public void setActionSteps(List<String> actionSteps) {
        this.actionSteps = actionSteps;
    }
}