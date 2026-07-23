"""Embedding 生成与 pgvector 入库脚本。"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from scripts.config import (
    CHUNKS_DIR,
    KB_VERSION,
    validate_config,
)
from utils.logger import get_logger
from utils.embedding import generate_embedding
from utils.db import get_connection, ensure_table, insert_chunk, version_exists

logger = get_logger("embed_and_insert")


def main() -> None:
    """批量生成 Embedding 并入库主入口。"""
    try:
        validate_config()
    except ValueError as e:
        logger.error(str(e))
        sys.exit(1)

    if not os.path.isdir(CHUNKS_DIR):
        logger.error(f"chunks目录不存在: {CHUNKS_DIR}，请先执行 chunk_text.py")
        sys.exit(1)

    chunk_files = [f for f in os.listdir(CHUNKS_DIR) if f.lower().endswith(".json")]
    if not chunk_files:
        logger.warning(f"chunks目录为空: {CHUNKS_DIR}")
        sys.exit(0)

    all_chunks: list[dict] = []
    for chunk_file in chunk_files:
        chunk_path = os.path.join(CHUNKS_DIR, chunk_file)
        try:
            with open(chunk_path, "r", encoding="utf-8") as f:
                chunks = json.load(f)
            if isinstance(chunks, list):
                all_chunks.extend(chunks)
        except Exception as e:
            logger.error(f"读取Chunk文件失败: {chunk_file} - {e}")

    if not all_chunks:
        logger.error("未读取到任何Chunk数据")
        sys.exit(1)

    logger.info(f"共 {len(all_chunks)} 个Chunk待处理")

    try:
        conn = get_connection()
    except ConnectionError as e:
        logger.error(str(e))
        sys.exit(1)

    try:
        ensure_table(conn)

        if version_exists(conn, KB_VERSION):
            logger.info(f"版本 {KB_VERSION} 已存在，跳过入库")
            return

        success = 0
        fail = 0
        skip = 0

        for i, chunk in enumerate(all_chunks, 1):
            chunk_id = chunk.get("chunk_id", "")
            content = chunk.get("content", "")

            if not content:
                skip += 1
                continue

            logger.info(f"处理 [{i}/{len(all_chunks)}] {chunk_id}")

            embedding = generate_embedding(content)
            if embedding is None:
                logger.error(f"Embedding生成失败: chunk_id={chunk_id}")
                fail += 1
                continue

            if insert_chunk(conn, chunk, embedding):
                success += 1
            else:
                fail += 1

        logger.info(
            f"入库完成: 成功 {success}, 失败 {fail}, 跳过 {skip}, "
            f"总计 {len(all_chunks)}"
        )

    finally:
        conn.close()


if __name__ == "__main__":
    main()