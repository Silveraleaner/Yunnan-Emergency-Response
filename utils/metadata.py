"""Metadata 生成模块，为每个 Chunk 附加结构化元数据。"""

import re
from typing import Any, Optional

from scripts.config import KB_VERSION, DOCUMENT_TYPE_MAP


def generate_metadata(
    chunk: dict[str, Any],
    full_text: str = "",
    pdf_filename: str = "",
) -> dict[str, Any]:
    """为单个 Chunk 生成完整的 Metadata。

    Args:
        chunk: 基础 Chunk 字典（含 chunk_id, document_name, content, order, page）。
        full_text: 原始文档全文，用于提取发布信息。
        pdf_filename: PDF 原始文件名，用于推断文档类型。

    Returns:
        包含完整 Metadata 的 Chunk 字典。
    """
    doc_name = chunk.get("document_name", "")
    content = chunk.get("content", "")

    chapter = _extract_chapter(content)
    section = _extract_section(content)
    document_type = _infer_document_type(doc_name, pdf_filename)
    source = _extract_source(full_text)
    publish_org = _extract_publish_org(full_text)
    publish_date = _extract_publish_date(full_text)

    chunk["chapter"] = chapter
    chunk["section"] = section
    chunk["document_type"] = document_type
    chunk["source"] = source
    chunk["publish_org"] = publish_org
    chunk["publish_date"] = publish_date
    chunk["version"] = KB_VERSION

    return chunk


def _extract_chapter(content: str) -> str:
    """从 Chunk 内容中提取一级章节编号。"""
    match = re.search(r"^\s*(\d+)\s*[\.．、]", content, re.MULTILINE)
    if match:
        return match.group(1)
    match = re.search(r"第([一二三四五六七八九十]+)章", content)
    if match:
        return match.group(1)
    return "未知"


def _extract_section(content: str) -> str:
    """从 Chunk 内容中提取二级章节编号。"""
    match = re.search(r"^\s*(\d+\.\d+)\s", content, re.MULTILINE)
    if match:
        return match.group(1)
    match = re.search(r"第([一二三四五六七八九十]+)节", content)
    if match:
        return match.group(1)
    return ""


def _infer_document_type(doc_name: str, pdf_filename: str) -> str:
    """根据文档名称推断文档类型。"""
    combined = doc_name + pdf_filename
    for keyword, doc_type in DOCUMENT_TYPE_MAP.items():
        if keyword in combined:
            return doc_type
    return "综合应急预案"


def _extract_source(full_text: str) -> str:
    """从全文中提取来源机构。"""
    patterns = [
        r"([^\s]{2,20}(?:人民政府|办公厅|应急厅|应急局|指挥部))",
    ]
    for pattern in patterns:
        match = re.search(pattern, full_text)
        if match:
            return match.group(1).strip()
    return "未知"


def _extract_publish_org(full_text: str) -> str:
    """从全文中提取发布单位。"""
    patterns = [
        r"发布单位[：:]\s*([^\n]{2,30})",
        r"印发单位[：:]\s*([^\n]{2,30})",
        r"([^\s]{2,20}(?:人民政府办公厅))",
    ]
    for pattern in patterns:
        match = re.search(pattern, full_text)
        if match:
            return match.group(1).strip()
    return _extract_source(full_text)


def _extract_publish_date(full_text: str) -> Optional[str]:
    """从全文中提取发布日期。"""
    patterns = [
        r"(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日",
        r"(\d{4})-(\d{2})-(\d{2})",
        r"(\d{4})\.(\d{2})\.(\d{2})",
    ]
    for pattern in patterns:
        match = re.search(pattern, full_text)
        if match:
            y, m, d = match.group(1), match.group(2), match.group(3)
            return f"{y}-{int(m):02d}-{int(d):02d}"
    return None