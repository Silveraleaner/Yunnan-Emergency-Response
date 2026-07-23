package com.project.service;

import com.project.entity.mysql.Incident;
import com.project.entity.mysql.Plan;
import com.project.repository.mysql.IncidentRepository;
import com.project.repository.mysql.PlanRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class PlanService {

    private static final Logger logger = LoggerFactory.getLogger(PlanService.class);
    private static final ExecutorService executorService = Executors.newCachedThreadPool();

    private final PlanRepository planRepository;
    private final IncidentRepository incidentRepository;

    public PlanService(PlanRepository planRepository, IncidentRepository incidentRepository) {
        this.planRepository = planRepository;
        this.incidentRepository = incidentRepository;
    }

    @Transactional("mysqlTransactionManager")
    public Map<String, String> generatePlan(String incidentId) {
        Incident incident = incidentRepository.findByIncidentId(incidentId)
                .orElseThrow(() -> new IllegalArgumentException("灾情不存在"));

        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String planId = UUID.randomUUID().toString();
        
        Plan plan = new Plan();
        plan.setPlanId(planId);
        plan.setIncidentId(incidentId);
        plan.setPlanTitle("应急预案 - " + incident.getIncidentName());
        plan.setPlanContent(generateMockPlanContent(incident));
        plan.setStatus("draft");

        planRepository.save(plan);

        Map<String, String> result = new HashMap<>();
        result.put("planId", planId);
        return result;
    }

    @Transactional("mysqlTransactionManager")
    public Plan getPlanById(String planId) {
        return planRepository.findByPlanId(planId)
                .orElseThrow(() -> new IllegalArgumentException("方案不存在"));
    }

    public List<Plan> getPlansByIncidentId(String incidentId) {
        return planRepository.findByIncidentId(incidentId);
    }

    public SseEmitter streamPlan(String incidentId) {
        SseEmitter emitter = new SseEmitter(60000L);

        executorService.execute(() -> {
            try {
                String planContent = generateMockPlanContent(null);
                int chunkSize = 10;
                
                for (int i = 0; i < planContent.length(); i += chunkSize) {
                    int end = Math.min(i + chunkSize, planContent.length());
                    String chunk = planContent.substring(i, end);
                    
                    emitter.send(SseEmitter.event()
                            .name("message")
                            .data(chunk));
                    
                    Thread.sleep(100);
                }

                emitter.complete();
                logger.info("SSE stream completed for incident: {}", incidentId);
            } catch (IOException e) {
                emitter.completeWithError(e);
                logger.error("SSE stream error", e);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                emitter.completeWithError(e);
                logger.warn("SSE stream interrupted");
            }
        });

        emitter.onCompletion(() -> logger.info("SSE emitter completed"));
        emitter.onTimeout(() -> logger.warn("SSE emitter timeout"));
        emitter.onError(e -> logger.error("SSE emitter error", e));

        return emitter;
    }

    private String generateMockPlanContent(Incident incident) {
        String disasterType = incident != null ? incident.getDisasterType() : "灾害";
        String location = incident != null && incident.getLocation() != null ? incident.getLocation() : "事发地点";

        return """
            【应急预案】

            一、灾情概况
            灾害类型：""" + disasterType + """
            发生地点：""" + location + """

            二、响应级别
            根据灾情严重程度，启动三级响应。

            三、组织指挥体系
            成立应急指挥部，统一指挥协调救援工作。

            四、应急处置措施
            1. 立即组织人员疏散，确保群众生命安全
            2. 调配救援物资和设备，保障救援需求
            3. 开展现场搜救，全力抢救被困人员
            4. 设置临时安置点，妥善安置受灾群众
            5. 加强卫生防疫，防止次生灾害发生

            五、资源保障
            - 救援队伍：消防、武警、专业救援队
            - 医疗物资：急救药品、医疗器械
            - 运输车辆：救护车、物资运输车
            - 通讯设备：卫星电话、对讲机

            六、信息报告与发布
            及时向相关部门报告灾情，统一发布信息。

            七、注意事项
            1. 救援人员注意自身安全
            2. 严格执行应急预案流程
            3. 保持信息畅通，及时反馈进展
            """;
    }
}