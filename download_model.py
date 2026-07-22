"""使用 ModelScope 国内源下载 Embedding 模型到本地"""
import os
from modelscope import snapshot_download

model_id = "Xorbits/bge-small-zh-v1.5"  # ModelScope 上的模型ID
local_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models", "bge-small-zh-v1.5")

print(f"开始从 ModelScope 下载模型 {model_id} 到 {local_dir} ...")
print("国内源下载速度极快，请稍候。")

snapshot_download(
    model_id=model_id,
    cache_dir=local_dir,  # 下载到本地指定目录
)
print("✅ 模型下载完成！")