package com.project.repository.postgres;

import com.project.entity.postgres.EmergencyPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmergencyPlanRepository extends JpaRepository<EmergencyPlan, Long> {

    Optional<EmergencyPlan> findByPlanId(String planId);

    List<EmergencyPlan> findByPlanType(String planType);

    @Query(value = "SELECT * FROM emergency_plans ORDER BY embedding <-> :embedding LIMIT :limit", nativeQuery = true)
    List<EmergencyPlan> findSimilarByEmbedding(@Param("embedding") float[] embedding, @Param("limit") int limit);
}