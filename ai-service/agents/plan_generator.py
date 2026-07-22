from typing import Dict, List


def generate_plan(incident_info: Dict[str, any], resources: List[Dict[str, any]], plan_chunks: List[Dict[str, any]]) -> str:
    """
    结合灾情信息、可用资源和 RAG 检索结果生成应急方案
    
    Args:
        incident_info: 灾情信息字典
        resources: 可用资源列表
        plan_chunks: RAG 检索到的历史方案片段
        
    Returns:
        完整的应急方案文本
    """
    # TODO: 调用 LLM 结合 RAG 结果生成完整方案
    pass