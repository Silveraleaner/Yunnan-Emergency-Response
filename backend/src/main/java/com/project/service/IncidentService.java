package com.project.service;

import com.project.dto.ai.EmergencyPlanDTO;
import com.project.dto.incident.IncidentRequest;
import com.project.dto.incident.IncidentResponse;
import com.project.entity.mysql.Incident;
import com.project.repository.mysql.IncidentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class IncidentService {

    private static final Logger logger = LoggerFactory.getLogger(IncidentService.class);

    private final IncidentRepository incidentRepository;
    private final LocationService locationService;
    private final AiDecisionService aiDecisionService;

    public IncidentService(IncidentRepository incidentRepository,
                           LocationService locationService,
                           AiDecisionService aiDecisionService) {
        this.incidentRepository = incidentRepository;
        this.locationService = locationService;
        this.aiDecisionService = aiDecisionService;
    }

    @Transactional("mysqlTransactionManager")
    public Incident createIncident(IncidentRequest request, Long reporterId) {
        Incident incident = new Incident();
        incident.setIncidentId(UUID.randomUUID().toString());
        incident.setTitle(request.getTitle());
        incident.setDescription(request.getDescription());
        incident.setIncidentType(request.getIncidentType());
        incident.setSeverity(request.getSeverity());
        incident.setStatus("待核验");
        incident.setReporterId(reporterId);

        return incidentRepository.save(incident);
    }

    public IncidentResponse reportIncident(IncidentRequest request, Long reporterId) {
        Incident incident = createIncident(request, reporterId);

        if (request.getLatitude() != null && request.getLongitude() != null) {
            locationService.createLocation(incident.getIncidentId(), request.getLatitude(), request.getLongitude());
        }

        String location = String.format("经纬度: %.6f, %.6f", request.getLatitude(), request.getLongitude());
        EmergencyPlanDTO emergencyPlan = aiDecisionService.generateEmergencyPlan(
                incident.getIncidentType(),
                location,
                incident.getSeverity()
        );

        IncidentResponse response = new IncidentResponse();
        response.setIncidentId(incident.getIncidentId());
        response.setTitle(incident.getTitle());
        response.setDescription(incident.getDescription());
        response.setIncidentType(incident.getIncidentType());
        response.setSeverity(incident.getSeverity());
        response.setStatus(incident.getStatus());
        response.setLatitude(request.getLatitude());
        response.setLongitude(request.getLongitude());
        response.setReportTime(incident.getReportTime());
        response.setCreatedAt(incident.getCreatedAt());
        response.setEmergencyPlan(emergencyPlan);

        return response;
    }

    @Transactional("mysqlTransactionManager")
    public Incident getIncidentById(String incidentId) {
        return incidentRepository.findByIncidentId(incidentId)
                .orElseThrow(() -> new IllegalArgumentException("灾情不存在"));
    }
}