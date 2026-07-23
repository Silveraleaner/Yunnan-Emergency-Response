package com.project.controller;

import com.project.common.Result;
import com.project.entity.mysql.Plan;
import com.project.service.PlanService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/plan")
@Validated
public class PlanController {

    private final PlanService planService;

    public PlanController(PlanService planService) {
        this.planService = planService;
    }

    @PostMapping("/generate")
    public ResponseEntity<Result<Map<String, String>>> generatePlan(
            @Valid @RequestBody GeneratePlanRequest request) {
        Map<String, String> result = planService.generatePlan(request.getIncidentId());
        return ResponseEntity.ok(Result.success("success", result));
    }

    @GetMapping("/detail")
    public ResponseEntity<Result<Plan>> getPlanDetail(
            @RequestParam @NotBlank(message = "planId不能为空") String planId) {
        Plan plan = planService.getPlanById(planId);
        return ResponseEntity.ok(Result.success(plan));
    }

    @GetMapping("/list")
    public ResponseEntity<Result<List<Plan>>> getPlanList(
            @RequestParam @NotBlank(message = "incidentId不能为空") String incidentId) {
        List<Plan> plans = planService.getPlansByIncidentId(incidentId);
        return ResponseEntity.ok(Result.success(plans));
    }

    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamPlan(
            @RequestParam @NotBlank(message = "incidentId不能为空") String incidentId) {
        SseEmitter emitter = planService.streamPlan(incidentId);
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("connected"));
        } catch (IOException e) {
            emitter.completeWithError(e);
        }
        return emitter;
    }

    public static class GeneratePlanRequest {
        @NotBlank(message = "incidentId不能为空")
        private String incidentId;

        public String getIncidentId() {
            return incidentId;
        }

        public void setIncidentId(String incidentId) {
            this.incidentId = incidentId;
        }
    }
}