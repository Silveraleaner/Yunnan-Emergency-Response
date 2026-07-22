package com.project.repository.mysql;

import com.project.entity.mysql.DispatchOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DispatchOrderRepository extends JpaRepository<DispatchOrder, Long> {

    Optional<DispatchOrder> findByOrderId(String orderId);

    List<DispatchOrder> findByIncidentId(String incidentId);

    List<DispatchOrder> findByStatus(String status);

    List<DispatchOrder> findByPriority(String priority);
}