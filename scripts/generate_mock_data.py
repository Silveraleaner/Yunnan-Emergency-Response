"""模拟数据生成主入口脚本。

生成用户、灾情、资源三类模拟数据，输出SQL和CSV文件至scripts/目录。

使用方式:
    python scripts/generate_mock_data.py
"""

import logging
import sys
import time
from pathlib import Path

from faker import Faker

from config import INCIDENT_COUNT, OUTPUT_DIR, RESOURCE_COUNT, USER_COUNT
from mock_incidents import generate_incidents
from mock_resources import generate_resources
from mock_users import generate_users, get_user_ids
from output_writer import write_sql_and_csv

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
)
logger = logging.getLogger(__name__)

SYS_USER_CREATE_SQL = """\
CREATE TABLE IF NOT EXISTS sys_user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    real_name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"""

INCIDENT_CREATE_SQL = """\
CREATE TABLE IF NOT EXISTS incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_name VARCHAR(100) NOT NULL,
    disaster_type VARCHAR(20) NOT NULL,
    incident_level VARCHAR(10) NOT NULL,
    occur_time DATETIME NOT NULL,
    location VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    reporter_id INT NOT NULL,
    report_time DATETIME NOT NULL,
    image_urls JSON DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"""

RESOURCE_CREATE_SQL = """\
CREATE TABLE IF NOT EXISTS resource (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    available_quantity INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'available',
    region VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"""


def main() -> None:
    """主入口函数，编排完整的数据生成流程。"""
    start_time = time.time()
    logger.info("=" * 60)
    logger.info("模拟数据生成脚本开始执行")
    logger.info("=" * 60)

    try:
        fake = Faker(locale="zh_CN")
    except Exception as e:
        logger.error("初始化Faker失败: %s", e)
        sys.exit(1)

    Path(OUTPUT_DIR).mkdir(parents=True, exist_ok=True)

    logger.info("正在生成用户数据 (%d 条)...", USER_COUNT)
    users = generate_users(fake, USER_COUNT)
    user_ids = get_user_ids(users)
    write_sql_and_csv(users, "users", OUTPUT_DIR, SYS_USER_CREATE_SQL)

    logger.info("正在生成灾情数据 (%d 条)...", INCIDENT_COUNT)
    incidents = generate_incidents(fake, INCIDENT_COUNT, user_ids)
    write_sql_and_csv(incidents, "incidents", OUTPUT_DIR, INCIDENT_CREATE_SQL)

    logger.info("正在生成资源数据 (%d 条)...", RESOURCE_COUNT)
    resources = generate_resources(fake, RESOURCE_COUNT)
    write_sql_and_csv(resources, "resources", OUTPUT_DIR, RESOURCE_CREATE_SQL)

    elapsed = time.time() - start_time
    logger.info("=" * 60)
    logger.info("模拟数据生成完成！")
    logger.info("  用户: %d 条 -> mock_users.sql / mock_users.csv", len(users))
    logger.info("  灾情: %d 条 -> mock_incidents.sql / mock_incidents.csv", len(incidents))
    logger.info("  资源: %d 条 -> mock_resources.sql / mock_resources.csv", len(resources))
    logger.info("  输出目录: %s/", OUTPUT_DIR)
    logger.info("  总耗时: %.2f 秒", elapsed)
    logger.info("=" * 60)


if __name__ == "__main__":
    main()