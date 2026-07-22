package com.project.repository.mysql;

import com.project.entity.mysql.Incident;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IncidentRepository extends JpaRepository<Incident, Long> {

    Optional<Incident> findByIncidentId(String incidentId);

    List<Incident> findByStatus(String status);

    List<Incident> findByReporterId(Long reporterId);

    List<Incident> findByIncidentType(String incidentType);
}