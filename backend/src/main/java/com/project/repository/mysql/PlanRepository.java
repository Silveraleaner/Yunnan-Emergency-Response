package com.project.repository.mysql;

import com.project.entity.mysql.Plan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlanRepository extends JpaRepository<Plan, Long> {

    Optional<Plan> findByPlanId(String planId);

    List<Plan> findByIncidentId(String incidentId);

    void deleteByPlanId(String planId);
}