package com.project.service;

import com.project.dto.incident.IncidentReportRequest;
import com.project.dto.incident.IncidentReportResponse;
import com.project.dto.incident.IncidentRequest;
import com.project.dto.incident.IncidentResponse;
import com.project.entity.mysql.Incident;
import com.project.repository.mysql.IncidentRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class IncidentService {

    private static final Logger logger = LoggerFactory.getLogger(IncidentService.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final int MAX_IMAGES = 5;

    private final IncidentRepository incidentRepository;
    private final ObjectMapper objectMapper;

    @Value("${app.upload.dir:./uploads}")
    private String uploadDir;

    public IncidentService(IncidentRepository incidentRepository, ObjectMapper objectMapper) {
        this.incidentRepository = incidentRepository;
        this.objectMapper = objectMapper;
    }

    @Transactional("mysqlTransactionManager")
    public IncidentReportResponse reportIncident(IncidentReportRequest request, Long reporterId) {
        Incident incident = new Incident();
        incident.setIncidentId(UUID.randomUUID().toString());
        incident.setIncidentName(request.getIncidentName());
        incident.setTitle(request.getIncidentName());
        incident.setDisasterType(request.getDisasterType());
        incident.setIncidentLevel(request.getIncidentLevel());
        incident.setOccurTime(request.getOccurTime());
        incident.setLocation(request.getLocation());
        incident.setDescription(request.getDescription());
        incident.setStatus("pending");
        incident.setReporterId(reporterId);

        List<String> imageUrls = new ArrayList<>();
        if (request.getImages() != null && request.getImages().length > 0) {
            int count = Math.min(request.getImages().length, MAX_IMAGES);
            for (int i = 0; i < count; i++) {
                MultipartFile file = request.getImages()[i];
                if (!file.isEmpty()) {
                    String url = saveImage(file, incident.getIncidentId());
                    if (url != null) {
                        imageUrls.add(url);
                    }
                }
            }
        }

        try {
            incident.setImageUrls(objectMapper.writeValueAsString(imageUrls));
        } catch (Exception e) {
            logger.warn("Failed to serialize imageUrls", e);
        }

        incidentRepository.save(incident);

        return new IncidentReportResponse(incident.getIncidentId(), imageUrls);
    }

    private String saveImage(MultipartFile file, String incidentId) {
        try {
            String dateDir = LocalDateTime.now().format(DATE_FORMATTER);
            Path uploadPath = Paths.get(uploadDir, dateDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String newFilename = incidentId + "_" + UUID.randomUUID().toString().substring(0, 8) + extension;
            Path filePath = uploadPath.resolve(newFilename);

            Files.copy(file.getInputStream(), filePath);
            String url = "/api/image/" + dateDir + "/" + newFilename;
            logger.info("Image saved: {}", url);
            return url;
        } catch (IOException e) {
            logger.error("Failed to save image", e);
            return null;
        }
    }

    @Transactional("mysqlTransactionManager")
    public Incident getIncidentById(String incidentId) {
        return incidentRepository.findByIncidentId(incidentId)
                .orElseThrow(() -> new IllegalArgumentException("灾情不存在"));
    }

    public Map<String, Object> listIncidents(Integer page, Integer size, String disasterType,
                                              String incidentLevel, String status, String keyword) {
        List<Incident> incidents = incidentRepository.findAll();
        
        if (disasterType != null && !disasterType.isEmpty()) {
            incidents = incidents.stream().filter(i -> disasterType.equals(i.getDisasterType())).toList();
        }
        if (incidentLevel != null && !incidentLevel.isEmpty()) {
            incidents = incidents.stream().filter(i -> incidentLevel.equals(i.getIncidentLevel())).toList();
        }
        if (status != null && !status.isEmpty()) {
            incidents = incidents.stream().filter(i -> status.equals(i.getStatus())).toList();
        }
        if (keyword != null && !keyword.isEmpty()) {
            String kw = keyword.toLowerCase();
            incidents = incidents.stream()
                    .filter(i -> i.getIncidentName().toLowerCase().contains(kw) ||
                            (i.getDescription() != null && i.getDescription().toLowerCase().contains(kw)) ||
                            (i.getLocation() != null && i.getLocation().toLowerCase().contains(kw)))
                    .toList();
        }

        int total = incidents.size();
        int start = (page - 1) * size;
        int end = Math.min(start + size, total);
        
        List<Incident> pageList = start < total ? incidents.subList(start, end) : new ArrayList<>();

        Map<String, Object> result = new HashMap<>();
        result.put("total", total);
        result.put("list", pageList);
        return result;
    }

    @Transactional("mysqlTransactionManager")
    public IncidentResponse submitIncident(IncidentRequest request, Long reporterId) {
        Incident incident = new Incident();
        incident.setIncidentId(UUID.randomUUID().toString());
        incident.setIncidentName(request.getTitle());
        incident.setDisasterType(request.getIncidentType());
        incident.setDescription(request.getDescription());
        incident.setStatus("pending");
        incident.setReporterId(reporterId);

        incidentRepository.save(incident);

        IncidentResponse response = new IncidentResponse();
        response.setIncidentId(incident.getIncidentId());
        response.setTitle(incident.getIncidentName());
        response.setDescription(incident.getDescription());
        response.setIncidentType(incident.getDisasterType());
        response.setStatus(incident.getStatus());
        response.setReportTime(incident.getReportTime());
        response.setCreatedAt(incident.getCreatedAt());

        return response;
    }
}