from typing import Dict, List


def review_plan(plan: str) -> Dict[str, any]:
    """
    审查应急方案的合规性和可行性
    
    Args:
        plan: 应急方案文本
        
    Returns:
        包含 score（评分）、issues（问题列表）、passed（是否通过）的字典
    """
    # TODO: 调用 LLM 检查方案合规性，生成审查结果
    pass