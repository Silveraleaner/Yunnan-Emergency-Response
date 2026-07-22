"""Chunk 切分模块，使用 LangChain RecursiveCharacterTextSplitter。"""

from typing import Any

from langchain_text_splitters import RecursiveCharacterTextSplitter

from scripts.config import CHUNK_SIZE, CHUNK_OVERLAP


def create_splitter(
    chunk_size: int = CHUNK_SIZE,
    chunk_overlap: int = CHUNK_OVERLAP,
) -> RecursiveCharacterTextSplitter:
    """创建文本切分器实例。

    Args:
        chunk_size: 每个 Chunk 的最大字符数。
        chunk_overlap: 相邻 Chunk 的重叠字符数。

    Returns:
        配置好的 RecursiveCharacterTextSplitter 实例。
    """
    return RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        separators=["\n\n", "\n", "。", "；", "，", " ", ""],
        length_function=len,
    )


def split_text(
    text: str,
    document_name: str,
    page_start: int = 1,
    chunk_size: int = CHUNK_SIZE,
    chunk_overlap: int = CHUNK_OVERLAP,
) -> list[dict[str, Any]]:
    """将文本切分为 Chunk 列表。

    Args:
        text: 待切分的文本。
        document_name: 所属文档名称。
        page_start: 起始页码。
        chunk_size: Chunk 大小。
        chunk_overlap: 重叠大小。

    Returns:
        Chunk 字典列表，每个包含 chunk_id, document_name, content, length, order, page。
    """
    if not text or not text.strip():
        return []

    splitter = create_splitter(chunk_size, chunk_overlap)
    segments = splitter.split_text(text)

    if not segments:
        return []

    chunks: list[dict[str, Any]] = []
    for idx, segment in enumerate(segments, start=1):
        content = segment.strip()
        if not content:
            continue
        chunk_id = f"{document_name}_{idx}"
        chunks.append({
            "chunk_id": chunk_id,
            "document_name": document_name,
            "content": content,
            "length": len(content),
            "order": idx,
            "page": page_start,
        })

    return chunks