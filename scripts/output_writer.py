"""模拟数据文件输出模块，支持SQL和CSV格式输出。"""

import csv
import logging
from pathlib import Path
from typing import Any

logger = logging.getLogger(__name__)


def write_sql_and_csv(
    data: list[dict[str, Any]],
    table_name: str,
    output_dir: str,
    create_table_sql: str,
) -> None:
    """将数据列表输出为SQL文件和CSV文件。

    Args:
        data: 数据字典列表，每个字典代表一行记录。
        table_name: 数据库表名，用于SQL INSERT语句和文件命名。
        output_dir: 输出目录路径。
        create_table_sql: CREATE TABLE IF NOT EXISTS DDL语句。
    """
    if not data:
        logger.warning("数据列表为空，跳过输出: %s", table_name)
        return

    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    columns = list(data[0].keys())

    _write_sql(data, table_name, output_dir, create_table_sql, columns)
    _write_csv(data, table_name, output_dir, columns)

    logger.info(
        "已输出 %s 数据: %d 条 -> %s/{mock_%s.sql, mock_%s.csv}",
        table_name,
        len(data),
        output_dir,
        table_name,
        table_name,
    )


def _write_sql(
    data: list[dict[str, Any]],
    table_name: str,
    output_dir: str,
    create_table_sql: str,
    columns: list[str],
) -> None:
    """生成SQL文件，包含CREATE TABLE和INSERT语句。"""
    sql_path = Path(output_dir) / f"mock_{table_name}.sql"
    try:
        with open(sql_path, "w", encoding="utf-8") as f:
            f.write(f"{create_table_sql};\n\n")
            for row in data:
                values = []
                for col in columns:
                    val = row[col]
                    if val is None:
                        values.append("NULL")
                    elif isinstance(val, (int, float)):
                        values.append(str(val))
                    else:
                        escaped = str(val).replace("'", "\\'")
                        values.append(f"'{escaped}'")
                col_names = ", ".join(columns)
                val_str = ", ".join(values)
                f.write(f"INSERT INTO {table_name} ({col_names}) VALUES ({val_str});\n")
        logger.info("SQL文件已生成: %s", sql_path)
    except OSError as e:
        logger.error("写入SQL文件失败: %s, 错误: %s", sql_path, e)
        raise


def _write_csv(
    data: list[dict[str, Any]],
    table_name: str,
    output_dir: str,
    columns: list[str],
) -> None:
    """生成UTF-8编码的CSV文件。"""
    csv_path = Path(output_dir) / f"mock_{table_name}.csv"
    try:
        with open(csv_path, "w", encoding="utf-8", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=columns)
            writer.writeheader()
            writer.writerows(data)
        logger.info("CSV文件已生成: %s", csv_path)
    except OSError as e:
        logger.error("写入CSV文件失败: %s, 错误: %s", csv_path, e)
        raise