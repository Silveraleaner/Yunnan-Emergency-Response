from typing import Dict, List


def dispatch_resources(incident_info: Dict[str, any]) -> List[Dict[str, any]]:
    """
    根据灾情信息调度可用资源
    
    Args:
        incident_info: 包含灾情类型、等级、位置等信息的字典
        
    Returns:
        推荐资源列表，每个资源包含类型、数量、位置等信息
    """
    # TODO: 调用后端 API 查询可用资源，根据灾情信息生成推荐列表
    pass