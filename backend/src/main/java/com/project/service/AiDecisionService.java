package com.project.service;

import com.project.dto.ai.EmergencyPlanDTO;

public interface AiDecisionService {

    EmergencyPlanDTO generateEmergencyPlan(String incidentType, String location, String severity);
}