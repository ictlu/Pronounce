from __future__ import annotations

import json
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

import pdfplumber


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "参考文件"
OUTPUT_DIR = ROOT / "content"
APP_RESOURCE_DIR = ROOT / "MedicalEnglishPronunciation" / "MedicalEnglishPronunciation" / "Resources"


@dataclass
class VocabularyEntry:
    id: str
    english: str
    ipa: str
    chinese: str
    definition: str = ""
    example_english: str = ""
    example_chinese: str = ""
    frequency: str = ""
    source_pdf: str = ""
    source_page: int = 0


@dataclass
class LiteratureParagraph:
    id: str
    english: str
    chinese: str
    vocabulary: list[str] = field(default_factory=list)


@dataclass
class LiteratureArticle:
    id: str
    source_pdf: str
    category: str
    topic: str
    title: str
    title_chinese: str
    journal: str
    year: str
    paragraphs: list[LiteratureParagraph]
    vocabulary: list[VocabularyEntry] = field(default_factory=list)
    source_page: int = 0


NOISE_LINES = {
    "究",
    "必",
    "权",
    "侵",
    "-",
    "山",
    "梦",
    "云",
}


def clean_line(line: str) -> str:
    line = line.replace("\x00", "").replace("\u3000", " ").strip()
    line = re.sub(r"@云梦.? vx：k06752439", "", line).strip()
    line = re.sub(r"第\s*\d+\s*页$", "", line).strip()
    if re.fullmatch(r"\d+", line):
        return ""
    if line in NOISE_LINES:
        return ""
    return line


def extract_pages(pdf_path: Path) -> list[tuple[int, list[str]]]:
    pages: list[tuple[int, list[str]]] = []
    with pdfplumber.open(pdf_path) as pdf:
        for index, page in enumerate(pdf.pages, start=1):
            raw_text = page.extract_text() or ""
            lines = [clean_line(line) for line in raw_text.splitlines()]
            lines = [line for line in lines if line]
            pages.append((index, lines))
    return pages


def normalize_space(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def slug(text: str, prefix: str) -> str:
    value = re.sub(r"[^A-Za-z0-9]+", "-", text.lower()).strip("-")
    return f"{prefix}-{value[:64]}" if value else prefix


def split_vocab_blocks(pages: list[tuple[int, list[str]]]) -> list[tuple[int, list[str]]]:
    blocks: list[tuple[int, list[str]]] = []
    current: list[str] = []
    current_page = 0
    entry_start = re.compile(r"^\d+\.\s+.+")

    for page_number, lines in pages:
        for line in lines:
            if entry_start.match(line):
                if current:
                    blocks.append((current_page, current))
                current = [line]
                current_page = page_number
            elif current:
                current.append(line)

    if current:
        blocks.append((current_page, current))
    return blocks


def parse_vocab_block(block: list[str], source_pdf: str, source_page: int) -> VocabularyEntry | None:
    if len(block) < 2 or not any(line.startswith("中文释义") for line in block):
        return None

    title_match = re.match(r"^(\d+)\.\s+(.+?)\s*$", block[0])
    if not title_match:
        return None

    number = title_match.group(1)
    english = normalize_space(title_match.group(2))
    definition_index = next(i for i, line in enumerate(block) if line.startswith("中文释义"))
    pronunciation_line = normalize_space(" ".join(block[1:definition_index]))
    ipa_match = re.match(r"^(/.+?/)\s+(.+?)(?:\s+【(.+?)】)?$", pronunciation_line)
    if not ipa_match:
        return None

    ipa = ipa_match.group(1).strip()
    chinese = normalize_space(ipa_match.group(2))
    frequency = ipa_match.group(3) or ""

    definition = section_text(block, "中文释义", ["记忆方法", "易混辨析", "常见搭配", "双语例句"])
    example_lines = section_lines(block, "双语例句", [])
    example_english = ""
    example_chinese = ""
    if example_lines:
        split_at = next((i for i, line in enumerate(example_lines) if has_cjk(line)), len(example_lines))
        example_english = normalize_space(" ".join(example_lines[:split_at]))
        example_chinese = normalize_space(" ".join(example_lines[split_at:]))

    return VocabularyEntry(
        id=f"vocab-{number}",
        english=english,
        ipa=ipa,
        chinese=chinese,
        definition=normalize_space(definition),
        example_english=example_english,
        example_chinese=example_chinese,
        frequency=frequency,
        source_pdf=source_pdf,
        source_page=source_page,
    )


def section_lines(lines: list[str], start_marker: str, end_markers: list[str]) -> list[str]:
    result: list[str] = []
    collecting = False
    for line in lines:
        if collecting and any(line.startswith(marker) for marker in end_markers):
            break
        if collecting:
            result.append(line)
        elif line.startswith(start_marker):
            collecting = True
    return result


def section_text(lines: list[str], start_marker: str, end_markers: list[str]) -> str:
    return " ".join(section_lines(lines, start_marker, end_markers))


def has_cjk(text: str) -> bool:
    return bool(re.search(r"[\u4e00-\u9fff]", text))


def mostly_english(text: str) -> bool:
    letters = len(re.findall(r"[A-Za-z]", text))
    cjk = len(re.findall(r"[\u4e00-\u9fff]", text))
    return letters > 0 and letters >= cjk


def parse_literature_articles(pdf_path: Path, pages: list[tuple[int, list[str]]]) -> list[LiteratureArticle]:
    page_by_line: list[tuple[int, str]] = []
    for page_number, lines in pages:
        for line in lines:
            page_by_line.append((page_number, line))

    starts = [i for i, (_, line) in enumerate(page_by_line) if " > " in line]
    articles: list[LiteratureArticle] = []
    for ordinal, start in enumerate(starts, start=1):
        end = starts[ordinal] if ordinal < len(starts) else len(page_by_line)
        chunk = page_by_line[start:end]
        article = parse_literature_chunk(pdf_path.name, ordinal, chunk)
        if article:
            articles.append(article)
    return articles


def parse_literature_chunk(source_pdf: str, ordinal: int, chunk: list[tuple[int, str]]) -> LiteratureArticle | None:
    if len(chunk) < 6:
        return None

    source_page = chunk[0][0]
    lines = [line for _, line in chunk]
    header = lines[0]
    category, topic = [part.strip() for part in header.split(" > ", 1)]

    try:
        journal_idx = next(i for i, line in enumerate(lines) if line.startswith("期刊:"))
        abstract_idx = next(i for i, line in enumerate(lines) if line == "Abstract")
        chinese_idx = next(i for i, line in enumerate(lines) if line.startswith("中文翻译"))
    except StopIteration:
        return None

    title_lines = lines[1:journal_idx]
    if len(title_lines) < 2:
        return None
    chinese_title_index = next((i for i, line in enumerate(title_lines) if has_cjk(line)), len(title_lines) - 1)
    title = clean_english_text(normalize_space(" ".join(title_lines[:chinese_title_index])))
    title_chinese = normalize_space(" ".join(title_lines[chinese_title_index:]))

    journal_line = lines[journal_idx]
    journal = ""
    year = ""
    journal_match = re.match(r"期刊:\s*(.*?)\s+日期:\s*(\d{4})", journal_line)
    if journal_match:
        journal = normalize_space(journal_match.group(1))
        year = journal_match.group(2)

    vocab_idx = next((i for i, line in enumerate(lines) if line.startswith("核心词汇")), len(lines))
    english_text = clean_english_text(normalize_space(" ".join(lines[abstract_idx + 1 : chinese_idx])))
    chinese_text = clean_chinese_text(normalize_space(" ".join(lines[chinese_idx + 1 : vocab_idx])))
    vocab_text = " ".join(lines[vocab_idx + 1 :]) if vocab_idx < len(lines) else ""

    if not title or not english_text or not chinese_text:
        return None

    article_id = f"article-{source_page}-{ordinal}"
    vocabulary = parse_inline_literature_vocabulary(vocab_text, source_pdf, source_page)
    vocab_terms = [item.english for item in vocabulary]

    paragraph = LiteratureParagraph(
        id=f"{article_id}-p1",
        english=english_text,
        chinese=chinese_text,
        vocabulary=vocab_terms,
    )

    return LiteratureArticle(
        id=article_id,
        source_pdf=source_pdf,
        category=category,
        topic=topic,
        title=title,
        title_chinese=title_chinese,
        journal=journal,
        year=year,
        paragraphs=[paragraph],
        vocabulary=vocabulary,
        source_page=source_page,
    )


def parse_inline_literature_vocabulary(text: str, source_pdf: str, source_page: int) -> list[VocabularyEntry]:
    if not text:
        return []

    pattern = re.compile(r"([A-Za-z][A-Za-z0-9 ,()'/-]{1,80})\s+(/[^/]+/)\s*:\s*([^/]+?)(?=\s+[A-Za-z][A-Za-z0-9 ,()'/-]{1,80}\s+/|$)")
    entries: list[VocabularyEntry] = []
    for match_index, match in enumerate(pattern.finditer(text), start=1):
        english = normalize_space(match.group(1))
        ipa = match.group(2).strip()
        chinese = normalize_space(match.group(3))
        if not english or not ipa or not chinese or not mostly_english(english):
            continue
        entries.append(
            VocabularyEntry(
                id=f"{slug(english, 'lit-vocab')}-{source_page}-{match_index}",
                english=english,
                ipa=ipa,
                chinese=chinese,
                source_pdf=source_pdf,
                source_page=source_page,
            )
        )
    return entries


def clean_english_text(text: str) -> str:
    text = re.sub(r"(?<=[A-Za-z])[\u4e00-\u9fff-]+(?=[A-Za-z])", "", text)
    text = re.sub(r"(?<=[A-Za-z])[\u4e00-\u9fff](?=\s)", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def clean_chinese_text(text: str) -> str:
    text = re.sub(r"(?<=[\u4e00-\u9fff])-(?=[\u4e00-\u9fff])", "", text)
    text = re.sub(r"(?<=[\u4e00-\u9fff])[山梦云](?=[\u4e00-\u9fff])", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def build_content() -> dict:
    pdfs = sorted(SOURCE_DIR.glob("*.pdf"))
    if not pdfs:
        raise FileNotFoundError(f"No PDF files found in {SOURCE_DIR}")

    vocabulary_pdf = next((pdf for pdf in pdfs if "核心词汇" in pdf.name), None)
    literature_pdfs = [pdf for pdf in pdfs if pdf != vocabulary_pdf]
    if vocabulary_pdf is None:
        raise FileNotFoundError("Could not identify the core vocabulary PDF.")

    vocab_pages = extract_pages(vocabulary_pdf)
    vocabulary = [
        entry
        for page, block in split_vocab_blocks(vocab_pages)
        if (entry := parse_vocab_block(block, vocabulary_pdf.name, page)) is not None
    ]

    articles: list[LiteratureArticle] = []
    for pdf in literature_pdfs:
        pages = extract_pages(pdf)
        articles.extend(parse_literature_articles(pdf, pages))

    content = {
        "metadata": {
            "title": "医学英语发音",
            "schemaVersion": 1,
            "sourcePdfs": [pdf.name for pdf in pdfs],
            "vocabularyCount": len(vocabulary),
            "articleCount": len(articles),
        },
        "vocabulary": [asdict(entry) for entry in vocabulary],
        "literature": [asdict(article) for article in articles],
    }
    return content


def main() -> int:
    content = build_content()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    APP_RESOURCE_DIR.mkdir(parents=True, exist_ok=True)

    output_path = OUTPUT_DIR / "medical_english_content.json"
    app_output_path = APP_RESOURCE_DIR / "medical_english_content.json"
    serialized = json.dumps(content, ensure_ascii=False, indent=2)
    output_path.write_text(serialized, encoding="utf-8")
    app_output_path.write_text(serialized, encoding="utf-8")

    print(f"Wrote {output_path}")
    print(f"Wrote {app_output_path}")
    print(f"Vocabulary entries: {content['metadata']['vocabularyCount']}")
    print(f"Literature articles: {content['metadata']['articleCount']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
