import logging


def setup_logger() -> logging.Logger:
    """
    配置全局日志记录器
    
    Returns:
        配置好的 logging.Logger 对象
    """
    logger = logging.getLogger("ai-service")
    logger.setLevel(logging.INFO)
    
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)
    
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    handler.setFormatter(formatter)
    
    logger.addHandler(handler)
    return logger