"""PDF 批量解析脚本，将 data/pdf/ 下的 PDF 解析为 data/txt/ 下的 txt 文件。"""

import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from scripts.config import PDF_DIR, TXT_DIR, validate_config
from utils.logger import get_logger
from utils.pdf_parser import extract_text_from_pdf

logger = get_logger("parse_pdfs")


def main() -> None:
    """批量解析 PDF 文件主入口。"""
    try:
        validate_config()
    except ValueError as e:
        logger.error(str(e))
        sys.exit(1)

    if not os.path.isdir(PDF_DIR):
        logger.error(f"PDF目录不存在: {PDF_DIR}")
        sys.exit(1)

    os.makedirs(TXT_DIR, exist_ok=True)

    pdf_files = [f for f in os.listdir(PDF_DIR) if f.lower().endswith(".pdf")]
    if not pdf_files:
        logger.warning(f"PDF目录为空: {PDF_DIR}")
        sys.exit(0)

    logger.info(f"发现 {len(pdf_files)} 个PDF文件，开始解析...")

    success_count = 0
    fail_count = 0
    total_start = time.time()

    for pdf_file in pdf_files:
        pdf_path = os.path.join(PDF_DIR, pdf_file)
        basename = os.path.splitext(pdf_file)[0]
        txt_path = os.path.join(TXT_DIR, f"{basename}.txt")

        start = time.time()
        try:
            text = extract_text_from_pdf(pdf_path)
            if text is None:
                logger.warning(f"PDF文件为空或损坏: {pdf_file}")
                fail_count += 1
                continue

            with open(txt_path, "w", encoding="utf-8") as f:
                f.write(text)

            elapsed = time.time() - start
            logger.info(f"解析完成: {pdf_file} -> {basename}.txt ({elapsed:.2f}s, {len(text)}字符)")
            success_count += 1

        except Exception as e:
            elapsed = time.time() - start
            logger.error(f"PDF文件损坏: {pdf_file} ({elapsed:.2f}s) - {type(e).__name__}: {e}")
            fail_count += 1

    total_elapsed = time.time() - total_start
    logger.info(
        f"批量解析完成: 成功 {success_count}, 失败 {fail_count}, "
        f"总耗时 {total_elapsed:.2f}s"
    )


if __name__ == "__main__":
    main()