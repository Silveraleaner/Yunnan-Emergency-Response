"""应急资源模拟数据生成模块。"""

import logging
from typing import Any

from faker import Faker

from config import RESOURCE_TYPES, YUNNAN_REGIONS

logger = logging.getLogger(__name__)

RESOURCE_TYPE_NAMES: dict[str, list[str]] = {
    "team": [
        "地震救援队", "山岳救援队", "水域救援队", "医疗救护队",
        "消防救援队", "通信保障队", "电力抢修队", "道路抢通队",
    ],
    "medical": [
        "急救药品", "外科手术包", "消毒用品", "防护装备",
        "输液器材", "担架", "急救箱", "止血器材",
    ],
    "vehicle": [
        "救护车", "消防车", "工程抢险车", "通信指挥车",
        "物资运输车", "无人机", "直升机", "冲锋舟",
    ],
    "shelter": [
        "救灾帐篷", "临时安置房", "避难场所", "过渡安置板房",
    ],
}


def generate_resources(fake: Faker, count: int = 100) -> list[dict[str, Any]]:
    """生成应急资源模拟数据。

    Args:
        fake: Faker实例（需zh_CN locale）。
        count: 生成数量，默认100。

    Returns:
        资源数据字典列表。
    """
    resources: list[dict[str, Any]] = []

    for i in range(count):
        resource_type = RESOURCE_TYPES[i % len(RESOURCE_TYPES)]
        type_names = RESOURCE_TYPE_NAMES[resource_type]
        resource_name = fake.random_element(type_names)
        region = fake.random_element(YUNNAN_REGIONS)

        quantity = fake.random_int(min=1, max=500)
        available_quantity = fake.random_int(min=0, max=quantity)
        available_quantity = min(available_quantity, quantity)

        status = "available" if available_quantity > 0 else "dispatched"

        resource = {
            "resource_id": i + 1,
            "resource_name": f"{region}{resource_name}",
            "resource_type": resource_type,
            "quantity": quantity,
            "available_quantity": available_quantity,
            "status": status,
            "region": region,
        }
        resources.append(resource)

    logger.info("已生成 %d 条资源数据", len(resources))
    return resources