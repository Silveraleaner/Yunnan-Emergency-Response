from typing import Dict


def extract_incident_info(description: str) -> Dict[str, any]:
    """
    从灾情描述中提取关键情报信息
    
    Args:
        description: 灾情描述文本
        
    Returns:
        包含 incident_type、magnitude、location（含 lat/lng）、affected_population、severity、confidence 的字典
    """
    # TODO: 调用 LLM 解析灾情描述，提取结构化信息
    pass