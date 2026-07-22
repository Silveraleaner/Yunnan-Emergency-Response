package com.project.repository.postgres;

import com.project.entity.postgres.Resource;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResourceRepository extends JpaRepository<Resource, Long> {

    Optional<Resource> findByResourceId(String resourceId);

    List<Resource> findByResourceType(String resourceType);

    List<Resource> findByStatus(String status);
}