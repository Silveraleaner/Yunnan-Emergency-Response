package com.project.repository.mysql;

import com.project.entity.mysql.DataSourceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DataSourceRepository extends JpaRepository<DataSourceEntity, Long> {

    Optional<DataSourceEntity> findBySourceId(String sourceId);

    List<DataSourceEntity> findBySourceType(String sourceType);

    List<DataSourceEntity> findByStatus(Integer status);
}