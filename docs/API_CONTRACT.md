```markdown
# AI 服务接口契约

## 基本信息
- **接口地址**：`http://113.55.4.50:8001/api/v1/generate-plan`
- **请求方式**：`POST`
- **响应格式**：SSE 流式（Server-Sent Events）
- **字符编码**：UTF-8

---

## 请求体格式

```json
{
  "incident_id": "INC-2026-001",
  "description": "昆明市盘龙区青云街道发生4.6级地震，震感强烈...",
  "location": {
    "lat": 25.04,
    "lng": 102.71
  }
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| incident_id | string | 是 | 灾情工单编号 |
| description | string | 是 | 灾情文字描述 |
| location.lat | float | 是 | 纬度 |
| location.lng | float | 是 | 经度 |

---

## 响应格式（SSE 流式）

响应类型为 `text/event-stream`，每个事件格式为：

```
event: <事件类型>
data: <JSON数据>
```

### 事件类型说明

| 事件类型 | 触发时机 | data 格式 |
|----------|----------|-----------|
| `start` | Agent 开始处理 | `{"incident_id": "xxx", "timestamp": "..."}` |
| `thought` | Agent 思考过程 | `{"content": "正在分析灾情信息..."}` |
| `tool_call` | 调用工具时 | `{"tool": "query_risk_zone", "status": "running"}` |
| `chunk` | 生成方案逐字输出 | `{"content": "根据"}` |
| `done` | 生成完成 | `{"plan": "完整方案文本", "citations": [...]}` |
| `error` | 发生错误 | `{"code": 500, "message": "..."}` |

### 响应示例

```
event: start
data: {"incident_id": "INC-2026-001"}

event: thought
data: {"content": "正在分析灾情信息..."}

event: thought
data: {"content": "识别到地震，等级4.6级，位置盘龙区"}

event: tool_call
data: {"tool": "query_risk_zone", "status": "running"}

event: chunk
data: {"content": "根据"}

event: chunk
data: {"content": "云南省地震应急预案"}

event: done
data: {"plan": "完整方案文本...", "citations": [{"source": "云南省地震应急预案", "text": "..."}]}
```

---

## 错误码定义

| 错误码 | 含义 | 处理方式 |
|--------|------|----------|
| 400 | 请求参数错误 | 检查请求体格式 |
| 404 | 灾情工单不存在 | 确认 incident_id 是否正确 |
| 500 | AI 服务内部错误 | 查看服务端日志 |
| 503 | vLLM 服务不可用 | 检查 vLLM 是否正常运行 |
| 504 | 推理超时 | 重试或联系管理员 |

### 错误响应示例（SSE）

```
event: error
data: {"code": 503, "message": "vLLM 服务不可用，请稍后重试"}
```

---

## 调用方式（Spring Boot 示例）

```java
WebClient webClient = WebClient.create();

Flux<String> stream = webClient.post()
    .uri("http://113.55.4.50:8001/api/v1/generate-plan")
    .bodyValue(request)
    .retrieve()
    .bodyToFlux(String.class);

// 前端通过 SSE 接收流式数据
```

---

## 更新记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|-----|----------|
| v1.0 | 2026-07-22 | 梁梓鑫 | 初始版本 |
```