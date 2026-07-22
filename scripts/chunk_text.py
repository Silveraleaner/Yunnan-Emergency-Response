"""Chunk 切分脚本，将 data/txt/ 下的文本切分为 Chunk 并保存至 data/chunks/。"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from scripts.config import TXT_DIR, CHUNKS_DIR, validate_config
from utils.logger import get_logger
from utils.chunker import split_text
from utils.metadata import generate_metadata

logger = get_logger("chunk_text")


def main() -> None:
    """批量切分文本主入口。"""
    try:
        validate_config()
    except ValueError as e:
        logger.error(str(e))
        sys.exit(1)

    if not os.path.isdir(TXT_DIR):
        logger.error(f"txt目录不存在: {TXT_DIR}，请先执行 parse_pdfs.py")
        sys.exit(1)

    os.makedirs(CHUNKS_DIR, exist_ok=True)

    txt_files = [f for f in os.listdir(TXT_DIR) if f.lower().endswith(".txt")]
    if not txt_files:
        logger.warning(f"txt目录为空: {TXT_DIR}")
        sys.exit(0)

    logger.info(f"发现 {len(txt_files)} 个txt文件，开始切分...")

    total_chunks = 0
    total_files = 0

    for txt_file in txt_files:
        txt_path = os.path.join(TXT_DIR, txt_file)
        document_name = os.path.splitext(txt_file)[0]

        try:
            with open(txt_path, "r", encoding="utf-8") as f:
                full_text = f.read()
        except Exception as e:
            logger.error(f"读取文件失败: {txt_file} - {e}")
            continue

        if not full_text or not full_text.strip():
            logger.warning(f"文件为空: {txt_file}")
            continue

        chunks = split_text(full_text, document_name)
        if not chunks:
            logger.warning(f"切分结果为空: {txt_file}")
            continue

        pdf_filename = f"{document_name}.pdf"
        for chunk in chunks:
            generate_metadata(chunk, full_text, pdf_filename)

        output_path = os.path.join(CHUNKS_DIR, f"{document_name}.json")
        try:
            with open(output_path, "w", encoding="utf-8") as f:
                json.dump(chunks, f, ensure_ascii=False, indent=2)
            logger.info(f"切分完成: {txt_file} -> {len(chunks)} 个Chunk")
            total_chunks += len(chunks)
            total_files += 1
        except Exception as e:
            logger.error(f"JSON序列化失败: {txt_file} - {e}")

    logger.info(f"批量切分完成: {total_files} 个文件, 共 {total_chunks} 个Chunk")


if __name__ == "__main__":
    main()