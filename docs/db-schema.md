# 云南应急响应平台 - 数据库结构文档

## 文档信息

| 属性 | 值 |
|------|------|
| 版本 | 1.0.0 |
| 数据库类型 | MySQL 8.0 + PostgreSQL 16 (PostGIS + pgvector) |
| 多数据源配置 | 双数据源分离，业务数据与空间/AI数据独立存储 |

---

## 数据源架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Spring Boot 应用                            │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────┐  ┌──────────────────────────────────┐ │
│  │   MySQL (emergency_db)    │  │   PostgreSQL (spatial_ai_db)     │ │
│  │   业务数据层              │  │   空间/AI数据层                  │ │
│  ├──────────────────────────┤  ├──────────────────────────────────┤ │
│  │ • users 用户表           │  │ • locations 空间位置表           │ │
│  │ • roles 角色表           │  │ • emergency_plans 应急预案表    │ │
│  │ • incidents 灾情表       │  │ • resources 资源表              │ │
│  │ • audit_logs 审计日志    │  │                                  │ │
│  │ • dispatch_orders 调度单 │  │ 🔶 PostGIS 几何类型支持          │ │
│  │ • incident_reports 报告  │  │ 🔶 pgvector 向量类型支持         │ │
│  └──────────────────────────┘  └──────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 一、MySQL 业务库 (emergency_db)

### 1.1 users - 用户表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 用户主键ID |
| username | VARCHAR(50) | NOT NULL, UNIQUE | 用户名 |
| password | VARCHAR(255) | NOT NULL | 加密后的密码 |
| email | VARCHAR(100) | UNIQUE | 邮箱地址 |
| phone | VARCHAR(20) | | 手机号码 |
| real_name | VARCHAR(50) | | 真实姓名 |
| role_id | BIGINT | FOREIGN KEY → roles(id) | 角色ID |
| status | INT | DEFAULT 1 | 状态（1-启用，0-禁用） |
| created_at | DATETIME | | 创建时间 |
| updated_at | DATETIME | | 更新时间 |

### 1.2 roles - 角色表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 角色主键ID |
| role_name | VARCHAR(50) | NOT NULL, UNIQUE | 角色名称（ADMIN/OPERATOR/VIEWER） |
| description | VARCHAR(200) | | 角色描述 |
| created_at | DATETIME | | 创建时间 |
| updated_at | DATETIME | | 更新时间 |

### 1.3 incidents - 灾情表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 主键ID |
| incident_id | VARCHAR(50) | NOT NULL, UNIQUE | 灾情唯一标识（UUID） |
| title | VARCHAR(200) | NOT NULL | 灾情标题 |
| description | VARCHAR(2000) | | 灾情描述 |
| incident_type | VARCHAR(50) | NOT NULL | 灾情类型（暴雨/地震/火灾等） |
| severity | VARCHAR(20) | NOT NULL | 严重程度（LOW/MEDIUM/HIGH/CRITICAL） |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'PENDING' | 状态（待核验/已核实/处理中/已完成） |
| reporter_id | BIGINT | FOREIGN KEY → users(id) | 上报人ID |
| report_time | DATETIME | | 上报时间 |
| created_at | DATETIME | | 创建时间 |
| updated_at | DATETIME | | 更新时间 |

### 1.4 audit_logs - 审计日志表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 主键ID |
| user_id | BIGINT | FOREIGN KEY → users(id) | 操作用户ID |
| operation | VARCHAR(100) | | 操作类型 |
| target_type | VARCHAR(50) | | 目标类型 |
| target_id | VARCHAR(50) | | 目标ID |
| detail | TEXT | | 操作详情 |
| ip_address | VARCHAR(50) | | 操作IP地址 |
| created_at | DATETIME | | 创建时间 |

### 1.5 dispatch_orders - 调度订单表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 主键ID |
| incident_id | VARCHAR(50) | NOT NULL | 关联灾情ID |
| resource_type | VARCHAR(50) | | 资源类型 |
| quantity | INT | | 数量 |
| status | VARCHAR(20) | | 状态 |
| dispatched_by | BIGINT | FOREIGN KEY → users(id) | 调度人ID |
| created_at | DATETIME | | 创建时间 |
| updated_at | DATETIME | | 更新时间 |

### 1.6 incident_reports - 灾情报告表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 主键ID |
| incident_id | VARCHAR(50) | NOT NULL | 关联灾情ID |
| report_type | VARCHAR(50) | | 报告类型 |
| content | TEXT | | 报告内容 |
| generated_at | DATETIME | | 生成时间 |
| created_at | DATETIME | | 创建时间 |

---

## 二、PostgreSQL 空间/AI库 (spatial_ai_db)

### 2.1 locations - 空间位置表

> **PostGIS 集成**：此表使用 PostGIS 扩展存储地理空间数据。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGSERIAL | PRIMARY KEY | 主键ID |
| incident_id | VARCHAR(50) | NOT NULL | 关联灾情ID |
| location | **geometry(Point, 4326)** | | ⚠️ **PostGIS Point 几何类型**，存储经纬度坐标（SRID 4326 表示 WGS84 坐标系） |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |

**空间查询示例**：

```sql
-- 查询某点附近10公里范围内的灾情
SELECT * FROM locations 
WHERE ST_DWithin(
    location, 
    ST_SetSRID(ST_MakePoint(102.8384, 24.8852), 4326)::geography, 
    10000
);

-- 获取坐标文本表示
SELECT incident_id, ST_AsText(location) FROM locations;
```

### 2.2 emergency_plans - 应急预案表

> **pgvector 集成**：此表预留了向量字段用于 AI 语义检索。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGSERIAL | PRIMARY KEY | 主键ID |
| plan_id | VARCHAR(64) | NOT NULL, UNIQUE | 预案唯一标识（UUID） |
| title | VARCHAR(200) | NOT NULL | 预案标题 |
| description | TEXT | | 预案描述 |
| plan_type | VARCHAR(50) | | 预案类型（暴雨预案/地震预案等） |
| keywords | TEXT[] | | 关键词数组 |
| embedding | **vector(1536)** | | ⚠️ **pgvector 向量类型**，用于存储 1536 维的文本嵌入向量，支持 ANN 相似度检索 |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 更新时间 |

**向量检索示例**：

```sql
-- 基于向量相似度检索相似预案（欧式距离）
SELECT * FROM emergency_plans
ORDER BY embedding <-> '[0.1, 0.2, ..., 0.1536]'
LIMIT 5;

-- 基于向量相似度检索（余弦距离）
SELECT * FROM emergency_plans
ORDER BY 1 - (embedding <=> '[0.1, 0.2, ..., 0.1536]')
LIMIT 5;
```

### 2.3 resources - 资源表

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGSERIAL | PRIMARY KEY | 主键ID |
| resource_id | VARCHAR(50) | NOT NULL, UNIQUE | 资源唯一标识 |
| name | VARCHAR(100) | NOT NULL | 资源名称 |
| resource_type | VARCHAR(50) | | 资源类型（消防/医疗/物资等） |
| quantity | INT | DEFAULT 0 | 数量 |
| location | geometry(Point, 4326) | | ⚠️ **PostGIS Point 几何类型**，资源所在位置 |
| status | VARCHAR(20) | DEFAULT 'AVAILABLE' | 状态（可用/调度中/已使用） |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 更新时间 |

---

## 三、数据库关系图

```
MySQL emergency_db:

┌──────────────┐     ┌──────────────┐
│    roles     │◄───│    users     │
│ ──────────── │     │ ──────────── │
│ • id (PK)    │     │ • id (PK)    │
│ • role_name  │     │ • username   │
│ • desc       │     │ • password   │
│              │     │ • role_id(FK)│
└──────────────┘     └──────┬───────┘
                            │
                            ▼
┌──────────────┐     ┌──────────────┐
│ audit_logs   │     │  incidents   │
│ ──────────── │     │ ──────────── │
│ • user_id(FK)│     │ • id (PK)    │
│ • operation  │     │ • incident_id│
│ • detail     │     │ • title      │
│              │     │ • severity   │
└──────────────┘     └──────┬───────┘
                            │
                            ▼
┌──────────────┐     ┌──────────────┐
│dispatch_orders│     │incident_reports│
│ ──────────── │     │ ──────────── │
│ • incident_id│     │ • incident_id│
│ • resource   │     │ • content    │
│ • status     │     │ • report_type│
└──────────────┘     └──────────────┘

PostgreSQL spatial_ai_db:

┌──────────────┐     ┌──────────────┐
│  locations   │     │emergency_plans│
│ ──────────── │     │ ──────────── │
│ • id (PK)    │     │ • id (PK)    │
│ • incident_id│────▶│ • plan_id    │
│ • location   │     │ • title      │
│ (PostGIS)    │     │ • embedding  │
│              │     │ (pgvector)   │
└──────────────┘     └──────────────┘
         │
         ▼
┌──────────────┐
│  resources   │
│ ──────────── │
│ • id (PK)    │
│ • name       │
│ • location   │
│ (PostGIS)    │
└──────────────┘
```

---

## 四、数据流转说明

1. **用户操作**：用户注册/登录 → 数据写入 MySQL `users`、`roles` 表
2. **灾情上报**：
   - 业务数据写入 MySQL `incidents` 表
   - 经纬度数据转换为 PostGIS Point 类型 → 写入 PostgreSQL `locations` 表
   - AI 生成应急方案 → 写入 PostgreSQL `emergency_plans` 表
3. **调度管理**：调度订单写入 MySQL `dispatch_orders` 表
4. **审计追踪**：所有操作记录写入 MySQL `audit_logs` 表

---

## 五、扩展说明

### 5.1 PostGIS 功能

- **坐标系统**：使用 WGS84 (SRID 4326) 标准地理坐标系
- **空间索引**：可在 `location` 字段创建 GIST 索引加速空间查询
- **空间函数**：支持距离计算、范围查询、几何运算等

### 5.2 pgvector 功能

- **向量维度**：预留 1536 维（适配 BERT-base 模型输出）
- **索引类型**：支持 HNSW、IVF 等近似最近邻索引
- **应用场景**：应急预案语义检索、灾情相似性分析