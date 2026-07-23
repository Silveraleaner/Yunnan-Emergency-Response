"""PDF 解析模块，使用 PyMuPDF 提取文本并保留章节结构。"""

import os
from typing import Optional

import fitz

from utils.text_cleaner import clean_text

PAGE_HEADER_MAX_LEN = 80
PAGE_FOOTER_PATTERN_COUNT = 2


def extract_text_from_pdf(pdf_path: str) -> Optional[str]:
    """从单个 PDF 文件中提取全部文本，自动去除页眉页脚页码。

    Args:
        pdf_path: PDF 文件路径。

    Returns:
        提取并清洗后的文本，失败返回 None。
    """
    try:
        doc = fitz.open(pdf_path)
    except Exception:
        return None

    if doc.page_count == 0:
        doc.close()
        return None

    all_text: list[str] = []
    for page_idx in range(doc.page_count):
        page = doc[page_idx]
        text = page.get_text("text")
        if not text or not text.strip():
            continue
        lines = text.split("\n")
        filtered = _filter_header_footer(lines, page_idx + 1, doc.page_count)
        page_text = "\n".join(filtered)
        if page_text.strip():
            all_text.append(page_text)

    doc.close()

    if not all_text:
        return None

    raw_text = "\n\n".join(all_text)
    cleaned = clean_text(raw_text)
    if not cleaned or len(cleaned.strip()) < 10:
        return None

    return cleaned


def _filter_header_footer(
    lines: list[str],
    page_num: int,
    total_pages: int,
) -> list[str]:
    """去除页眉、页脚和页码行。

    Args:
        lines: 单页文本按行拆分的列表。
        page_num: 当前页码（1-based）。
        total_pages: 总页数。

    Returns:
        过滤后的行列表。
    """
    if not lines:
        return lines

    filtered = list(lines)

    if len(filtered) >= 2:
        first = filtered[0].strip()
        if len(first) <= PAGE_HEADER_MAX_LEN and not _looks_like_content(first):
            filtered.pop(0)

    if len(filtered) >= 1:
        last = filtered[-1].strip()
        if _is_page_number(last, page_num):
            filtered.pop(-1)

    if len(filtered) >= 1:
        last = filtered[-1].strip()
        if len(last) <= PAGE_HEADER_MAX_LEN and not _looks_like_content(last):
            filtered.pop(-1)

    return filtered


def _is_page_number(text: str, expected_num: int) -> bool:
    """判断文本是否为页码。"""
    stripped = text.strip()
    if stripped == str(expected_num):
        return True
    if stripped == f"- {expected_num} -":
        return True
    if stripped == f"— {expected_num} —":
        return True
    clean = stripped.lstrip("- —").rstrip("- —").strip()
    return clean == str(expected_num)


def _looks_like_content(text: str) -> bool:
    """判断文本是否像正文内容（而非页眉页脚）。"""
    if not text:
        return False
    chinese_count = sum(1 for c in text if "\u4e00" <= c <= "\u9fff")
    return chinese_count >= 3


def parse_pdf_to_txt(pdf_path: str, txt_dir: str) -> Optional[str]:
    """解析单个 PDF 并将清洗后的文本保存为 txt 文件。

    Args:
        pdf_path: PDF 文件路径。
        txt_dir: txt 输出目录。

    Returns:
        输出的 txt 文件路径，失败返回 None。
    """
    basename = os.path.splitext(os.path.basename(pdf_path))[0]
    txt_path = os.path.join(txt_dir, f"{basename}.txt")

    text = extract_text_from_pdf(pdf_path)
    if text is None:
        return None

    os.makedirs(txt_dir, exist_ok=True)
    with open(txt_path, "w", encoding="utf-8") as f:
        f.write(text)

    return txt_path