package com.project.entity.postgres;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@Entity
@Table(name = "resources")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Resource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "resource_id", unique = true, nullable = false, length = 64)
    private String resourceId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "resource_type", length = 50)
    private String resourceType;

    @Column(name = "quantity")
    private Integer quantity;

    @Column(name = "unit", length = 20)
    private String unit;

    @Column(name = "status", length = 20)
    private String status;

    @Column(name = "location", columnDefinition = "GEOMETRY(Point, 4326)")
    private Point location;

    @Column(name = "storage_address", length = 500)
    private String storageAddress;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = "available";
        }
        if (quantity == null) {
            quantity = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}