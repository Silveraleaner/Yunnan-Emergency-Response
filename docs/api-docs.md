# 云南应急响应平台 - API 接口文档

## 文档信息

| 属性 | 值 |
|------|------|
| 版本 | 1.0.0 |
| 基础URL | `http://localhost:8080` |
| 内容类型 | `application/json` |
| 认证方式 | JWT Bearer Token |

---

## 接口列表

| 接口名称 | 请求方法 | URL | 响应时间 | 需要认证 |
|----------|----------|-----|----------|----------|
| 用户注册 | POST | `/api/auth/register` | ~500ms | 否 |
| 用户登录 | POST | `/api/auth/login` | ~350ms | 否 |
| 灾情上报 | POST | `/api/incidents` | ~2s | 是 |

---

## 1. 用户注册

**响应时间**：约 500ms

**功能描述**：用户注册账号，系统自动分配默认角色。

**请求方法**：POST

**URL**：`{{baseUrl}}/api/auth/register`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Content-Type | application/json | 是 |

**请求体**：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名，长度 3-50 |
| password | String | 是 | 密码，长度 6-100 |
| realName | String | 否 | 真实姓名 |

**请求示例**：

```json
{
  "username": "admin",
  "password": "123456",
  "realName": "系统管理员"
}
```

**响应示例**：

```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "id": 1,
    "username": "admin",
    "email": null,
    "phone": null,
    "realName": "系统管理员",
    "roleId": 2,
    "status": 1,
    "createdAt": "2026-07-22T16:30:00",
    "updatedAt": "2026-07-22T16:30:00"
  },
  "timestamp": "2026-07-22T16:30:00"
}
```

**错误响应**：

```json
{
  "code": 400,
  "message": "用户名已存在",
  "data": null,
  "timestamp": "2026-07-22T16:30:00"
}
```

---

## 2. 用户登录

**响应时间**：约 350ms

**功能描述**：用户登录系统，获取 JWT Token 用于后续接口认证。

**请求方法**：POST

**URL**：`{{baseUrl}}/api/auth/login`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Content-Type | application/json | 是 |

**请求体**：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名 |
| password | String | 是 | 密码 |

**请求示例**：

```json
{
  "username": "admin",
  "password": "123456"
}
```

**响应示例**：

```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhZG1pbiIsImlhdCI6MTc4NDcwOTk1NCwiZXhwIjoxNzg0Nzk2MzU0fQ.Q8oga-paGbCZNqCVEMF7D3QlkW1MrTjkz688TYMKoIjAA4-wckH1k3vb7viZafO3",
    "tokenType": "Bearer",
    "expiresIn": 86400000,
    "username": "admin",
    "realName": "管理员",
    "roleName": "VIEWER"
  },
  "timestamp": "2026-07-22T16:45:54"
}
```

**错误响应**：

```json
{
  "code": 401,
  "message": "用户名或密码错误",
  "data": null,
  "timestamp": "2026-07-22T16:45:54"
}
```

---

## 3. 灾情上报

**响应时间**：约 2s（其中 1.5s 为 AI Mock 延迟）

**功能描述**：上报灾情信息，触发 AI 应急方案生成，数据同时写入 MySQL 和 PostgreSQL 双库。

**请求方法**：POST

**URL**：`{{baseUrl}}/api/incidents`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Content-Type | application/json | 是 |
| Authorization | Bearer `<token>` | 是 |

**请求体**：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | String | 是 | 灾情标题，长度 1-200 |
| description | String | 否 | 灾情描述，长度 0-2000 |
| incidentType | String | 是 | 灾情类型（如：暴雨、地震、火灾等） |
| severity | String | 是 | 严重程度（LOW/MEDIUM/HIGH/CRITICAL） |
| latitude | Double | 是 | 纬度 |
| longitude | Double | 是 | 经度 |

**请求示例**：

```json
{
  "title": "昆明暴雨灾害",
  "description": "昆明市五华区遭遇强降雨，部分路段积水严重。",
  "incidentType": "暴雨",
  "severity": "MEDIUM",
  "latitude": 24.8852,
  "longitude": 102.8384
}
```

**响应示例**：

```json
{
  "code": 200,
  "message": "上报成功",
  "data": {
    "incidentId": "eca3233c-aa16-4a21-bfc7-652e79452fd4",
    "title": "昆明暴雨灾害",
    "description": "昆明市五华区遭遇强降雨，部分路段积水严重。",
    "incidentType": "暴雨",
    "severity": "MEDIUM",
    "status": "待核验",
    "latitude": 24.8852,
    "longitude": 102.8384,
    "reportTime": "2026-07-22T16:45:54",
    "createdAt": "2026-07-22T16:45:54",
    "emergencyPlan": {
      "responseLevel": "三级响应",
      "estimatedImpact": "预计有一定程度的人员伤亡和财产损失",
      "recommendedResources": "消防车5辆，医疗队2支，无人机1架",
      "actionSteps": [
        "启动应急预案，成立应急指挥部",
        "核实灾情信息，确认受灾范围",
        "组织救援力量到达现场",
        "调配必要的应急物资",
        "疏散受灾群众到安全区域",
        "开展医疗救助和卫生防疫",
        "评估灾情并上报上级部门"
      ]
    }
  },
  "timestamp": "2026-07-22T16:45:56"
}
```

**错误响应**：

```json
{
  "code": 401,
  "message": "未授权",
  "data": null,
  "timestamp": "2026-07-22T16:45:56"
}
```

---

## 统一响应格式

所有接口返回统一格式：

| 字段 | 类型 | 说明 |
|------|------|------|
| code | Integer | 状态码，200 表示成功 |
| message | String | 响应消息 |
| data | Object | 响应数据 |
| timestamp | String | 响应时间戳 |

**状态码说明**：

| 状态码 | 含义 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误或业务逻辑错误 |
| 401 | 未授权或 Token 无效 |
| 500 | 服务器内部错误 |