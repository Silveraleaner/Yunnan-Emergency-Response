package com.project.service;

import com.project.entity.postgres.Location;
import com.project.repository.postgres.LocationRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LocationService {

    private final LocationRepository locationRepository;
    private final GeometryFactory geometryFactory;

    public LocationService(LocationRepository locationRepository) {
        this.locationRepository = locationRepository;
        this.geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
    }

    @Transactional("postgresTransactionManager")
    public Location createLocation(String incidentId, Double latitude, Double longitude) {
        Location location = new Location();
        location.setIncidentId(incidentId);

        if (latitude != null && longitude != null) {
            Coordinate coordinate = new Coordinate(longitude, latitude);
            Point point = geometryFactory.createPoint(coordinate);
            location.setCoordinates(point);
        }

        return locationRepository.save(location);
    }
}