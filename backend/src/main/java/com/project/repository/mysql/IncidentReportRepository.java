package com.project.repository.mysql;

import com.project.entity.mysql.IncidentReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IncidentReportRepository extends JpaRepository<IncidentReport, Long> {

    List<IncidentReport> findByIncidentId(String incidentId);

    List<IncidentReport> findByReporterId(Long reporterId);
}