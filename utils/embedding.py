"""Embedding 生成模块，使用 BAAI/bge-small-zh-v1.5 模型。"""

from typing import Optional

from utils.logger import get_logger

logger = get_logger("embedding")

_model = None
_tokenizer = None


# def _load_model(model_name: str = "BAAI/bge-small-zh-v1.5"):
#     """延迟加载 Embedding 模型和 tokenizer。

#     Args:
#         model_name: HuggingFace 模型名称。

#     Returns:
#         (model, tokenizer) 元组。
#     """
#     global _model, _tokenizer
#     if _model is not None and _tokenizer is not None:
#         return _model, _tokenizer

#     try:
#         from transformers import AutoTokenizer, AutoModel
#         _tokenizer = AutoTokenizer.from_pretrained(model_name)
#         _model = AutoModel.from_pretrained(model_name)
#         _model.eval()
#         logger.info(f"Embedding模型加载成功: {model_name}")
#     except Exception as e:
#         logger.error(f"Embedding模型加载失败: {e}")
#         raise
#     return _model, _tokenizer
import os
def _load_model(model_name: str = "BAAI/bge-small-zh-v1.5"):
    """延迟加载 Embedding 模型和 tokenizer。

    Args:
        model_name: HuggingFace 模型名称。

    Returns:
        (model, tokenizer) 元组。
    """
    global _model, _tokenizer
    if _model is not None and _tokenizer is not None:
        return _model, _tokenizer

    try:
        from transformers import AutoTokenizer, AutoModel
        
        # 优先从本地 models 目录加载
        local_model_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "models", "bge-small-zh-v1.5")
        
        if os.path.exists(local_model_path):
            logger.info(f"从本地路径加载模型: {local_model_path}")
            _tokenizer = AutoTokenizer.from_pretrained(local_model_path)
            _model = AutoModel.from_pretrained(local_model_path)
        else:
            logger.info(f"本地未找到模型，从网络加载: {model_name}")
            _tokenizer = AutoTokenizer.from_pretrained(model_name)
            _model = AutoModel.from_pretrained(model_name)
            
        _model.eval()
        logger.info(f"Embedding模型加载成功")
    except Exception as e:
        logger.error(f"Embedding模型加载失败: {e}")
        raise
    return _model, _tokenizer


def generate_embedding(
    text: str,
    model_name: str = "BAAI/bge-small-zh-v1.5",
) -> Optional[list[float]]:
    """生成单条文本的 Embedding 向量。

    Args:
        text: 待编码的文本。
        model_name: 模型名称。

    Returns:
        512 维浮点数列表，失败返回 None。
    """
    if not text or not text.strip():
        return None

    try:
        import torch
        model, tokenizer = _load_model(model_name)
        encoded = tokenizer(text, padding=True, truncation=True, max_length=512, return_tensors="pt")
        with torch.no_grad():
            output = model(**encoded)
        attention_mask = encoded["attention_mask"]
        token_embeddings = output.last_hidden_state
        input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
        embedding = torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(
            input_mask_expanded.sum(1), min=1e-9
        )
        vector = embedding.squeeze().tolist()
        return vector
    except Exception as e:
        logger.error(f"Embedding生成失败: {e}")
        return None


def generate_embeddings_batch(
    texts: list[str],
    model_name: str = "BAAI/bge-small-zh-v1.5",
) -> list[Optional[list[float]]]:
    """批量生成 Embedding 向量。

    Args:
        texts: 待编码的文本列表。
        model_name: 模型名称。

    Returns:
        与输入等长的向量列表，单项失败时对应位置为 None。
    """
    results: list[Optional[list[float]]] = []
    for text in texts:
        vec = generate_embedding(text, model_name)
        results.append(vec)
    return results