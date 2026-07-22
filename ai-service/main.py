from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import uvicorn
import os

app = FastAPI(title="DisasterX AI Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health():
    return {"status": "ok", "service": "ai-service"}


# ============ 新增：加载本地 Qwen2.5 ============
print("正在加载 Qwen2.5-7B 模型...")
model = AutoModelForCausalLM.from_pretrained(
    "Qwen/Qwen2.5-7B-Instruct",
    device_map="auto",
    torch_dtype=torch.float16
)
tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-7B-Instruct")
print("✅ 模型加载成功！")


# ============ 新增：AI 接口 ============
@app.post("/api/v1/generate-plan")
async def generate_plan(request: Request):
    data = await request.json()
    description = data.get("description", "")

    # 用本地模型推理
    messages = [{"role": "user", "content": f"分析灾情：{description}"}]
    text = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
    inputs = tokenizer(text, return_tensors="pt").to(model.device)
    outputs = model.generate(**inputs, max_new_tokens=512, do_sample=True, temperature=0.7)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)

    return {"plan": response}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)


# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
#
# app = FastAPI(title="DisasterX AI Service", version="1.0.0")
#
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )
#
# @app.get("/health")
# async def health():
#     return {"status": "ok", "service": "ai-service"}