package com.project.controller;

import com.project.common.Result;
import com.project.dto.incident.IncidentRequest;
import com.project.dto.incident.IncidentResponse;
import com.project.service.IncidentService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/incidents")
public class IncidentController {

    private final IncidentService incidentService;

    public IncidentController(IncidentService incidentService) {
        this.incidentService = incidentService;
    }

    @PostMapping
    public ResponseEntity<Result<IncidentResponse>> reportIncident(
            @Valid @RequestBody IncidentRequest request,
            Authentication authentication) {
        String username = authentication.getName();
        Long reporterId = 1L;
        IncidentResponse response = incidentService.reportIncident(request, reporterId);
        return ResponseEntity.ok(Result.success("上报成功", response));
    }

    @GetMapping("/{incidentId}")
    public ResponseEntity<Result<com.project.entity.mysql.Incident>> getIncident(
            @PathVariable String incidentId) {
        com.project.entity.mysql.Incident incident = incidentService.getIncidentById(incidentId);
        return ResponseEntity.ok(Result.success(incident));
    }
}