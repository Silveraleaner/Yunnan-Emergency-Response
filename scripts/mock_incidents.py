"""灾情模拟数据生成模块。"""

import logging
from typing import Any

from faker import Faker

from config import DISASTER_TYPES, INCIDENT_LEVELS, INCIDENT_STATUSES, YUNNAN_REGIONS

logger = logging.getLogger(__name__)

DISASTER_TYPE_LABELS: dict[str, str] = {
    "earthquake": "地震",
    "mudslide": "泥石流",
    "flood": "洪涝",
    "drought": "干旱",
    "landslide": "山体滑坡",
    "fire": "森林火灾",
    "other": "其他",
}

INCIDENT_LEVEL_LABELS: dict[str, str] = {
    "I": "Ⅰ级",
    "II": "Ⅱ级",
    "III": "Ⅲ级",
    "IV": "Ⅳ级",
}


def generate_incidents(
    fake: Faker,
    count: int = 50,
    user_ids: list[int] | None = None,
) -> list[dict[str, Any]]:
    """生成灾情模拟数据。

    Args:
        fake: Faker实例（需zh_CN locale）。
        count: 生成数量，默认50。
        user_ids: 合法的上报人ID列表，reporter_id将从中选取。

    Returns:
        灾情数据字典列表。
    """
    if user_ids is None:
        user_ids = list(range(1, 21))

    incidents: list[dict[str, Any]] = []

    type_count = _distribute_evenly(count, len(DISASTER_TYPES))
    level_count = _distribute_evenly(count, len(INCIDENT_LEVELS))
    status_count = _distribute_evenly(count, len(INCIDENT_STATUSES))

    for i in range(count):
        disaster_type = DISASTER_TYPES[i % len(DISASTER_TYPES)]
        incident_level = INCIDENT_LEVELS[i % len(INCIDENT_LEVELS)]
        status = INCIDENT_STATUSES[i % len(INCIDENT_STATUSES)]

        region = fake.random_element(YUNNAN_REGIONS)
        occur_time = fake.date_time_between(start_date="-1y", end_date="now")
        report_time = fake.date_time_between(start_date=occur_time, end_date="now")

        incident = {
            "incident_id": i + 1,
            "incident_name": _generate_incident_name(fake, disaster_type, region),
            "disaster_type": disaster_type,
            "incident_level": incident_level,
            "occur_time": occur_time.strftime("%Y-%m-%d %H:%M:%S"),
            "location": f"{region}{fake.city_suffix()}{fake.street_address()}",
            "description": fake.text(max_nb_chars=200),
            "status": status,
            "reporter_id": fake.random_element(user_ids),
            "report_time": report_time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        incidents.append(incident)

    logger.info("已生成 %d 条灾情数据", len(incidents))
    return incidents


def _distribute_evenly(total: int, groups: int) -> list[int]:
    """将total均匀分配到groups个组中。"""
    base = total // groups
    remainder = total % groups
    return [base + (1 if i < remainder else 0) for i in range(groups)]


def _generate_incident_name(fake: Faker, disaster_type: str, region: str) -> str:
    """生成灾情事件名称。"""
    type_label = DISASTER_TYPE_LABELS.get(disaster_type, "灾害")
    level_label = fake.random_element(list(INCIDENT_LEVEL_LABELS.values()))
    return f"{region}{type_label}灾害{fake.random_int(min=1, max=999)}"