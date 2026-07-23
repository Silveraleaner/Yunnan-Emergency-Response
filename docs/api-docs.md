# 云南应急响应平台 - API 接口文档

## 文档信息

| 属性 | 值 |
|------|------|
| 版本 | 2.0.0 |
| 基础URL | `http://localhost:8080` |
| 默认内容类型 | `application/json` |
| 认证方式 | JWT Bearer Token |

---

## 接口列表

| 接口名称 | 请求方法 | URL | 响应时间 | 需要认证 |
|----------|----------|-----|----------|----------|
| 用户注册 | POST | `/api/auth/register` | ~500ms | 否 |
| 用户登录 | POST | `/api/auth/login` | ~350ms | 否 |
| 灾情上报 | POST | `/api/incident/report` | ~500ms | 是 |
| 获取灾情详情 | GET | `/api/incident/detail` | ~100ms | 是 |
| 获取灾情列表 | GET | `/api/incident/list` | ~150ms | 是 |
| 生成方案 (REST) | POST | `/api/plan/generate` | ~500ms | 是 |
| 获取方案详情 | GET | `/api/plan/detail` | ~100ms | 是 |
| 获取方案列表 | GET | `/api/plan/list` | ~150ms | 是 |
| 方案流式输出 (SSE) | GET | `/api/plan/stream` | 持续推送 | 是 |

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
  "code": 0,
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
  "code": 0,
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

**响应时间**：约 500ms

**功能描述**：上报灾情信息，支持图文混合上传，数据写入 MySQL 数据库。

**请求方法**：POST

**URL**：`{{baseUrl}}/api/incident/report`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Content-Type | multipart/form-data | 是 |
| Authorization | Bearer `<token>` | 是 |

**请求参数**（FormData 格式）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incidentName | String | 是 | 灾情名称，长度 1-200 |
| disasterType | String | 是 | 灾害类型（如：flood、earthquake、fire 等） |
| incidentLevel | String | 否 | 灾情级别（I/II/III/IV） |
| location | String | 否 | 发生地点 |
| description | String | 否 | 灾情描述，长度 0-2000 |
| images | File[] | 否 | 图片文件数组，最多 5 张 |

**请求示例**（curl）：

```bash
curl -X POST http://localhost:8080/api/incident/report \
  -H "Authorization: Bearer <token>" \
  -F "incidentName=昆明暴雨灾害" \
  -F "disasterType=flood" \
  -F "incidentLevel=III" \
  -F "location=昆明市五华区" \
  -F "description=昆明市五华区遭遇强降雨，部分路段积水严重。" \
  -F "images=@image1.jpg" \
  -F "images=@image2.jpg"
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32",
    "imageUrls": [
      "/api/image/20260723/baadad56-1f14-4ad5-8c3f-1fc3f0e35f32_abc123.jpg",
      "/api/image/20260723/baadad56-1f14-4ad5-8c3f-1fc3f0e35f32_def456.jpg"
    ]
  },
  "timestamp": "2026-07-23T10:40:44"
}
```

**错误响应**：

```json
{
  "code": 400,
  "message": "灾情名称不能为空",
  "data": null,
  "timestamp": "2026-07-23T10:40:44"
}
```

---

## 4. 获取灾情详情

**响应时间**：约 100ms

**功能描述**：根据灾情 ID 获取灾情详细信息。

**请求方法**：GET

**URL**：`{{baseUrl}}/api/incident/detail`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Authorization | Bearer `<token>` | 是 |

**请求参数**（Query）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incidentId | String | 是 | 灾情唯一标识 |

**请求示例**：

```bash
curl http://localhost:8080/api/incident/detail?incidentId=baadad56-1f14-4ad5-8c3f-1fc3f0e35f32 \
  -H "Authorization: Bearer <token>"
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32",
    "incidentName": "昆明暴雨灾害",
    "disasterType": "flood",
    "incidentLevel": "III",
    "location": "昆明市五华区",
    "description": "昆明市五华区遭遇强降雨，部分路段积水严重。",
    "status": "pending",
    "imageUrls": "[\"/api/image/20260723/xxx.jpg\"]",
    "reporterId": 1,
    "reportTime": "2026-07-23T10:40:44",
    "createdAt": "2026-07-23T10:40:44",
    "updatedAt": "2026-07-23T10:40:44"
  },
  "timestamp": "2026-07-23T10:45:00"
}
```

---

## 5. 获取灾情列表

**响应时间**：约 150ms

**功能描述**：分页获取灾情列表，支持多条件筛选。

**请求方法**：GET

**URL**：`{{baseUrl}}/api/incident/list`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Authorization | Bearer `<token>` | 是 |

**请求参数**（Query）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| page | Integer | 否 | 页码，默认 1 |
| size | Integer | 否 | 每页条数，默认 10 |
| disasterType | String | 否 | 灾害类型筛选 |
| incidentLevel | String | 否 | 灾情级别筛选 |
| status | String | 否 | 状态筛选 |
| keyword | String | 否 | 关键词搜索（匹配名称、描述、地点） |

**请求示例**：

```bash
curl "http://localhost:8080/api/incident/list?page=1&size=10&disasterType=flood" \
  -H "Authorization: Bearer <token>"
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 50,
    "list": [
      {
        "id": 1,
        "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32",
        "incidentName": "昆明暴雨灾害",
        "disasterType": "flood",
        "incidentLevel": "III",
        "status": "pending",
        "reportTime": "2026-07-23T10:40:44",
        "createdAt": "2026-07-23T10:40:44"
      }
    ]
  },
  "timestamp": "2026-07-23T10:45:00"
}
```

---

## 6. AI 方案生成 (REST)

**响应时间**：约 500ms

**功能描述**：根据灾情 ID 触发 AI 方案生成，返回方案 ID。方案生成采用异步处理，需后续通过轮询获取结果。

**请求方法**：POST

**URL**：`{{baseUrl}}/api/plan/generate`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Content-Type | application/json | 是 |
| Authorization | Bearer `<token>` | 是 |

**请求体**：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incidentId | String | 是 | 灾情唯一标识 |

**请求示例**：

```json
{
  "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32"
}
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "planId": "dccb4264-b725-46d0-a959-964bf1fef6c1"
  },
  "timestamp": "2026-07-23T10:40:57"
}
```

---

## 7. 获取方案详情

**响应时间**：约 100ms

**功能描述**：根据方案 ID 获取方案详细内容。

**请求方法**：GET

**URL**：`{{baseUrl}}/api/plan/detail`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Authorization | Bearer `<token>` | 是 |

**请求参数**（Query）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| planId | String | 是 | 方案唯一标识 |

**请求示例**：

```bash
curl http://localhost:8080/api/plan/detail?planId=dccb4264-b725-46d0-a959-964bf1fef6c1 \
  -H "Authorization: Bearer <token>"
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "planId": "dccb4264-b725-46d0-a959-964bf1fef6c1",
    "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32",
    "planTitle": "应急预案 - 昆明暴雨灾害",
    "planContent": "【应急预案】\n\n一、灾情概况\n灾害类型：暴雨\n发生地点：昆明市五华区\n\n二、响应级别\n根据灾情严重程度，启动三级响应。\n\n三、组织指挥体系\n成立应急指挥部，统一指挥协调救援工作。\n\n四、应急处置措施\n...",
    "generateTime": "2026-07-23T10:40:57",
    "status": "draft",
    "createdAt": "2026-07-23T10:40:57",
    "updatedAt": "2026-07-23T10:40:57"
  },
  "timestamp": "2026-07-23T10:45:00"
}
```

---

## 8. 获取方案列表

**响应时间**：约 150ms

**功能描述**：根据灾情 ID 获取该灾情相关的所有方案列表。

**请求方法**：GET

**URL**：`{{baseUrl}}/api/plan/list`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Authorization | Bearer `<token>` | 是 |

**请求参数**（Query）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incidentId | String | 是 | 灾情唯一标识 |

**请求示例**：

```bash
curl http://localhost:8080/api/plan/list?incidentId=baadad56-1f14-4ad5-8c3f-1fc3f0e35f32 \
  -H "Authorization: Bearer <token>"
```

**响应示例**：

```json
{
  "code": 0,
  "message": "success",
  "data": [
    {
      "id": 1,
      "planId": "dccb4264-b725-46d0-a959-964bf1fef6c1",
      "incidentId": "baadad56-1f14-4ad5-8c3f-1fc3f0e35f32",
      "planTitle": "应急预案 - 昆明暴雨灾害",
      "status": "draft",
      "generateTime": "2026-07-23T10:40:57",
      "createdAt": "2026-07-23T10:40:57"
    }
  ],
  "timestamp": "2026-07-23T10:45:00"
}
```

---

## 9. AI 方案流式输出 (SSE)

**响应类型**：Server-Sent Events (SSE)

**响应时间**：持续推送，约 3-5 秒完成

**功能描述**：根据灾情 ID 触发 AI 方案生成，并通过 SSE 流式推送方案内容，实现打字机效果。

**请求方法**：GET

**URL**：`{{baseUrl}}/api/plan/stream?incidentId={id}`

**请求头**：

| 名称 | 值 | 必填 |
|------|-----|------|
| Accept | text/event-stream | 是 |
| Cache-Control | no-cache | 是 |
| Authorization | Bearer `<token>` | 是 |

**请求参数**（Query）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incidentId | String | 是 | 灾情唯一标识 |

**请求示例**（curl）：

```bash
curl -N -X GET "http://localhost:8080/api/plan/stream?incidentId=baadad56-1f14-4ad5-8c3f-1fc3f0e35f32" \
  -H "Accept: text/event-stream" \
  -H "Cache-Control: no-cache" \
  -H "Authorization: Bearer <token>"
```

**响应格式**（标准 SSE 报文）：

```
event: connect
data: connected

event: message
data: 【应急预案】

event: message
data: 一、灾情概况

event: message
data: 灾害类型：暴雨

event: message
data: 发生地点：昆明市五华区

event: message
data: 二、响应级别

event: message
data: 根据灾情严重程度，启动三级响应。

event: message
data: 三、组织指挥体系

...（持续推送）
```

**响应说明**：

| 字段 | 说明 |
|------|------|
| event: connect | 连接成功事件，推送一次 |
| event: message | 消息事件，持续推送方案内容片段 |
| data: | 每次推送的数据内容，逐字追加展示 |

**前端处理方式**：

```typescript
// 使用 fetch API 处理 SSE
const response = await fetch('/api/plan/stream?incidentId=xxx', {
  headers: {
    'Accept': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Authorization': 'Bearer <token>'
  }
})

const reader = response.body.getReader()
const decoder = new TextDecoder('utf-8')
let buffer = ''

while (true) {
  const { done, value } = await reader.read()
  if (done) break
  
  buffer += decoder.decode(value, { stream: true })
  const lines = buffer.split('\n')
  buffer = lines.pop() || ''
  
  for (const line of lines) {
    if (line.startsWith('data: ')) {
      const content = line.slice(6)
      // 将 content 追加到响应式变量中，实现打字机效果
    }
  }
}
```

**注意事项**：

1. **必须使用 SSE 兼容的客户端**：不能使用普通 Axios，需使用原生 `fetch`、`EventSource` 或 `@microsoft/fetch-event-source` 库
2. **请求头要求**：必须携带 `Accept: text/event-stream` 和 `Cache-Control: no-cache`
3. **连接管理**：需正确处理连接的正常关闭、超时和异常情况
4. **打字机效果**：前端需将每次收到的 `data:` 内容逐字追加到展示区域

---

## 统一响应格式

所有接口返回统一格式：

| 字段 | 类型 | 说明 |
|------|------|------|
| code | Integer | 状态码，**0 表示成功** |
| message | String | 响应消息 |
| data | Object | 响应数据 |
| timestamp | String | 响应时间戳 |

**状态码说明**：

| 状态码 | 含义 |
|--------|------|
| **0** | 成功 |
| 400 | 请求参数错误或业务逻辑错误 |
| 401 | 未授权或 Token 无效 |
| 500 | 服务器内部错误 |

---

## SSE 流式接口特殊说明

### SSE 协议格式

服务器发送事件（Server-Sent Events）是一种单向的服务器到客户端的通信协议，协议格式如下：

```
event: <事件名称>
data: <数据内容>

event: <事件名称>
data: <数据内容>
```

### 支持的事件类型

| 事件名称 | 触发时机 | 数据内容 |
|----------|----------|----------|
| connect | 连接建立时 | "connected" |
| message | 方案内容生成时 | 方案文本片段 |

### 前端实现建议

1. **推荐使用 `@microsoft/fetch-event-source` 库**，简化 SSE 处理逻辑
2. 使用 Vue3 组合式 API，将收到的数据追加到 `ref` 响应式变量中
3. 实现加载状态、错误处理和取消功能
4. 使用 `pre` 标签或 `white-space: pre-wrap` CSS 属性保持文本格式