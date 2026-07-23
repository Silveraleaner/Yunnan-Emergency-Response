"""文本清洗模块，去除多余空格、重复换行、统一标点和编码。"""

import re
import unicodedata


_EN_PUNCT_TO_CN = {
    ",": "，",
    ".": "。",
    ";": "；",
    ":": "：",
    "!": "！",
    "?": "？",
    "(": "（",
    ")": "）",
}

_CHINESE_RANGE = (0x4E00, 0x9FFF)


def clean_text(raw: str) -> str:
    """对原始文本执行全流程清洗。

    Args:
        raw: 原始提取文本。

    Returns:
        清洗后的文本。
    """
    if not raw:
        return ""

    text = _remove_invisible_chars(raw)
    text = _normalize_line_breaks(text)
    text = _normalize_spaces(text)
    text = _unify_punctuation(text)
    text = _remove_garbage_lines(text)

    return text.strip()


def _remove_invisible_chars(text: str) -> str:
    """删除零宽空格、控制字符等不可见字符。"""
    result: list[str] = []
    for ch in text:
        if unicodedata.category(ch).startswith("C") and ch not in ("\n", "\r", "\t"):
            continue
        if ch in ("\u200b", "\u200c", "\u200d", "\ufeff", "\u00ad"):
            continue
        result.append(ch)
    return "".join(result)


def _normalize_line_breaks(text: str) -> str:
    """将连续多个换行合并为最多一个空行。"""
    return re.sub(r"\n{3,}", "\n\n", text)


def _normalize_spaces(text: str) -> str:
    """删除行首行尾空格，将连续空格合并为单个。"""
    lines: list[str] = []
    for line in text.split("\n"):
        stripped = line.strip()
        stripped = re.sub(r" {2,}", " ", stripped)
        lines.append(stripped)
    return "\n".join(lines)


def _unify_punctuation(text: str) -> str:
    """在中文上下文中将英文标点转换为中文标点。"""
    result: list[str] = []
    chars = list(text)
    for i, ch in enumerate(chars):
        if ch not in _EN_PUNCT_TO_CN:
            result.append(ch)
            continue
        prev_cn = _is_chinese(chars, i - 1) if i > 0 else False
        next_cn = _is_chinese(chars, i + 1) if i < len(chars) - 1 else False
        if prev_cn or next_cn:
            result.append(_EN_PUNCT_TO_CN[ch])
        else:
            result.append(ch)
    return "".join(result)


def _is_chinese(chars: list[str], idx: int) -> bool:
    """判断 chars[idx] 是否为中文字符。"""
    if idx < 0 or idx >= len(chars):
        return False
    code = ord(chars[idx])
    return _CHINESE_RANGE[0] <= code <= _CHINESE_RANGE[1]


def _remove_garbage_lines(text: str) -> str:
    """删除乱码行（非中文、非标点、非数字的字符占比过高的行）。"""
    lines: list[str] = []
    for line in text.split("\n"):
        if not line.strip():
            lines.append(line)
            continue
        if _is_garbage_line(line):
            continue
        lines.append(line)
    return "\n".join(lines)


def _is_garbage_line(line: str) -> bool:
    """判断一行是否为乱码行。"""
    stripped = line.strip()
    if not stripped:
        return False
    total = len(stripped)
    garbage = 0
    for ch in stripped:
        cat = unicodedata.category(ch)
        if cat.startswith("C"):
            garbage += 1
        elif cat == "Co" or cat == "Cn":
            garbage += 1
        elif ord(ch) > 0xFFFF and not ("\u4e00" <= ch <= "\u9fff"):
            garbage += 1
    ratio = garbage / total if total > 0 else 0
    return ratio > 0.5