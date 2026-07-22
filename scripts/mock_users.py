"""用户模拟数据生成模块。"""

import logging
from datetime import datetime, timedelta
from typing import Any

from faker import Faker

from config import DEFAULT_PASSWORD, USER_ROLE_DISTRIBUTION

logger = logging.getLogger(__name__)


def generate_users(fake: Faker, count: int = 20) -> list[dict[str, Any]]:
    """生成用户模拟数据。

    Args:
        fake: Faker实例（需zh_CN locale）。
        count: 生成数量，默认20。

    Returns:
        用户数据字典列表。
    """
    users: list[dict[str, Any]] = []
    used_usernames: set[str] = set()

    for role, role_count in USER_ROLE_DISTRIBUTION.items():
        for _ in range(role_count):
            username = _generate_unique_username(fake, used_usernames)
            used_usernames.add(username)

            user = {
                "user_id": len(users) + 1,
                "username": username,
                "real_name": fake.name(),
                "password": _hash_password(DEFAULT_PASSWORD),
                "role": role,
                "phone": _generate_phone(fake),
                "email": fake.email() if fake.boolean(chance_of_getting_true=70) else None,
                "created_at": fake.date_time_between(start_date="-1y", end_date="now").strftime(
                    "%Y-%m-%d %H:%M:%S"
                ),
            }
            users.append(user)

    logger.info("已生成 %d 条用户数据", len(users))
    return users


def _generate_unique_username(fake: Faker, used: set[str]) -> str:
    """生成唯一用户名，确保不重复。"""
    for _ in range(100):
        username = fake.user_name()
        if username not in used and 4 <= len(username) <= 20:
            return username
    return fake.user_name() + str(len(used))


def _generate_phone(fake: Faker) -> str:
    """生成11位中国大陆手机号。"""
    prefixes = ["130", "131", "132", "133", "135", "136", "137", "138", "139",
                "150", "151", "152", "155", "156", "157", "158", "159",
                "170", "176", "177", "178", "180", "181", "182", "183", "185", "186", "187", "188", "189"]
    prefix = fake.random_element(prefixes)
    suffix = "".join([str(fake.random_digit()) for _ in range(8)])
    return prefix + suffix


def _hash_password(password: str) -> str:
    """使用bcrypt加密密码。

    若bcrypt不可用，返回明文（仅用于开发环境）。
    """
    try:
        import bcrypt
        return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
    except ImportError:
        logger.warning("bcrypt库未安装，密码将以明文存储（仅限开发环境）")
        return password


def get_user_ids(users: list[dict[str, Any]]) -> list[int]:
    """从用户数据列表中提取所有user_id。"""
    return [u["user_id"] for u in users]