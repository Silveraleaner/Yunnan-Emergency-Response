CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgvector;

CREATE TABLE IF NOT EXISTS locations (
    id BIGSERIAL PRIMARY KEY,
    incident_id VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(100),
    address VARCHAR(500),
    coordinates GEOMETRY(Point, 4326),
    accuracy DECIMAL(10,6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS resources (
    id BIGSERIAL PRIMARY KEY,
    resource_id VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    quantity INT DEFAULT 0,
    unit VARCHAR(20),
    status VARCHAR(20) DEFAULT 'available',
    location GEOMETRY(Point, 4326),
    storage_address VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS emergency_plans (
    id BIGSERIAL PRIMARY KEY,
    plan_id VARCHAR(64) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    plan_type VARCHAR(50),
    keywords TEXT[],
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_locations_coordinates ON locations USING GIST (coordinates);
CREATE INDEX IF NOT EXISTS idx_resources_location ON resources USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_emergency_plans_embedding ON emergency_plans USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);