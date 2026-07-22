package com.project.entity.mysql;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "dispatch_orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DispatchOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_id", unique = true, nullable = false, length = 64)
    private String orderId;

    @Column(name = "incident_id", nullable = false, length = 64)
    private String incidentId;

    @Column(name = "content", columnDefinition = "TEXT")
    private String content;

    @Column(name = "target_users", columnDefinition = "TEXT")
    private String targetUsers;

    @Column(name = "priority", length = 20)
    private String priority;

    @Column(name = "status", length = 20)
    private String status;

    @Column(name = "dispatch_time")
    private LocalDateTime dispatchTime;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = "待处理";
        }
        if (dispatchTime == null) {
            dispatchTime = LocalDateTime.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}