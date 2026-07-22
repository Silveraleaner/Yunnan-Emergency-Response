package com.project.service;

import com.project.dto.ai.EmergencyPlanDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Profile("dev")
public class AiDecisionServiceMockImpl implements AiDecisionService {

    private static final Logger logger = LoggerFactory.getLogger(AiDecisionServiceMockImpl.class);

    private static final Map<String, String> RESPONSE_LEVEL_MAP = new HashMap<>();
    private static final Map<String, String> IMPACT_MAP = new HashMap<>();
    private static final Map<String, String> RESOURCES_MAP = new HashMap<>();

    static {
        RESPONSE_LEVEL_MAP.put("特别重大", "一级响应");
        RESPONSE_LEVEL_MAP.put("重大", "一级响应");
        RESPONSE_LEVEL_MAP.put("较大", "二级响应");
        RESPONSE_LEVEL_MAP.put("一般", "三级响应");
        RESPONSE_LEVEL_MAP.put("洪水", "二级响应");
        RESPONSE_LEVEL_MAP.put("地震", "一级响应");
        RESPONSE_LEVEL_MAP.put("山体滑坡", "二级响应");
        RESPONSE_LEVEL_MAP.put("泥石流", "二级响应");
        RESPONSE_LEVEL_MAP.put("火灾", "二级响应");
        RESPONSE_LEVEL_MAP.put("干旱", "三级响应");

        IMPACT_MAP.put("特别重大", "预计受灾人数超10000人，直接经济损失超10亿元");
        IMPACT_MAP.put("重大", "预计受灾人数1000-10000人，直接经济损失1-10亿元");
        IMPACT_MAP.put("较大", "预计受灾人数100-1000人，直接经济损失1000万-1亿元");
        IMPACT_MAP.put("一般", "预计受灾人数少于100人，直接经济损失少于1000万元");

        RESOURCES_MAP.put("洪水", "冲锋舟10艘、救生衣200件、沙袋5000袋、水泵20台、医疗队3支");
        RESOURCES_MAP.put("地震", "救援队伍5支、生命探测仪5台、挖掘机10台、急救物资50吨、帐篷200顶");
        RESOURCES_MAP.put("山体滑坡", "挖掘机8台、推土机5台、救援队3支、急救药品20箱");
        RESOURCES_MAP.put("泥石流", "装载机10台、运输车20辆、冲锋舟5艘、救援队2支");
        RESOURCES_MAP.put("火灾", "消防车10辆、灭火无人机5架、消防队员100人、医疗急救队2支");
        RESOURCES_MAP.put("干旱", "运水车20辆、抗旱设备100套、饮用水100吨、医疗防疫队1支");
    }

    @Override
    public EmergencyPlanDTO generateEmergencyPlan(String incidentType, String location, String severity) {
        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String responseLevel = RESPONSE_LEVEL_MAP.getOrDefault(severity, RESPONSE_LEVEL_MAP.getOrDefault(incidentType, "三级响应"));
        String estimatedImpact = IMPACT_MAP.getOrDefault(severity, "预计有一定程度的人员伤亡和财产损失");
        String recommendedResources = RESOURCES_MAP.getOrDefault(incidentType, "消防车5辆，医疗队2支，无人机1架");

        List<String> actionSteps = generateActionSteps(incidentType, severity);

        EmergencyPlanDTO plan = new EmergencyPlanDTO();
        plan.setResponseLevel(responseLevel);
        plan.setEstimatedImpact(estimatedImpact);
        plan.setRecommendedResources(recommendedResources);
        plan.setActionSteps(actionSteps);

        logger.info("========== AI 应急决策方案生成 ==========");
        logger.info("灾情类型: {}", incidentType);
        logger.info("发生地点: {}", location);
        logger.info("严重程度: {}", severity);
        logger.info("响应级别: {}", plan.getResponseLevel());
        logger.info("预估受灾: {}", plan.getEstimatedImpact());
        logger.info("推荐资源: {}", plan.getRecommendedResources());
        logger.info("处置步骤: {}", plan.getActionSteps());
        logger.info("==========================================");

        return plan;
    }

    private List<String> generateActionSteps(String incidentType, String severity) {
        return switch (incidentType) {
            case "地震" -> Arrays.asList(
                    "立即启动地震应急预案，成立现场指挥部",
                    "派遣专业救援队前往灾区进行人员搜救",
                    "调运帐篷、食品、饮用水等应急物资",
                    "组织医疗队伍开展伤员救治",
                    "疏散灾区群众到安全地带",
                    "开展次生灾害监测和防范工作",
                    "评估灾情损失并上报上级部门"
            );
            case "洪水" -> Arrays.asList(
                    "启动防洪应急预案，密切监测水位变化",
                    "组织群众转移到高处或临时安置点",
                    "调配冲锋舟和救生设备进行抢险救援",
                    "加固堤坝，封堵决口",
                    "疏散低洼地区居民",
                    "做好饮用水消毒和卫生防疫",
                    "统计受灾情况并上报"
            );
            case "山体滑坡" -> Arrays.asList(
                    "立即封锁滑坡区域，禁止人员进入",
                    "疏散周边居民到安全地带",
                    "派遣地质专家评估滑坡稳定性",
                    "调配重型机械清理滑坡体",
                    "设置警示标志和监测设备",
                    "评估道路和建筑受损情况",
                    "制定恢复重建方案"
            );
            case "火灾" -> Arrays.asList(
                    "立即拨打火警电话，启动火灾应急预案",
                    "组织人员疏散，确保生命安全",
                    "调配消防车辆和灭火设备",
                    "切断电源和易燃易爆物品",
                    "组织专业消防队灭火",
                    "开展伤员救治和心理疏导",
                    "调查火灾原因和损失评估"
            );
            default -> Arrays.asList(
                    "启动应急预案，成立应急指挥部",
                    "核实灾情信息，确认受灾范围",
                    "组织救援力量赶赴现场",
                    "调运必要的应急物资",
                    "疏散受灾群众到安全区域",
                    "开展医疗救助和卫生防疫",
                    "评估灾情并上报上级部门"
            );
        };
    }
}