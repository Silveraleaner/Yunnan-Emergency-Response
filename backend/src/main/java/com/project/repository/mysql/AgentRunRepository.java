package com.project.repository.mysql;

import com.project.entity.mysql.AgentRun;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AgentRunRepository extends JpaRepository<AgentRun, Long> {

    Optional<AgentRun> findByRunId(String runId);

    List<AgentRun> findByIncidentId(String incidentId);

    List<AgentRun> findByStatus(String status);

    List<AgentRun> findByAgentName(String agentName);
}