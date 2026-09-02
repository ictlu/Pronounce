# 数据质量报告

- Generated: 2026-08-31
- Source PDFs:
  - `参考文件/内分泌科复试核心词汇表.pdf`
  - `参考文件/内分泌2026文献翻译合集-云梦山制作-任何问题+k06752439.pdf`
  - `参考文件/内分泌经典文献翻译合集-云梦山制作-任何问题加k06752439.pdf`
- Structured output: `content/medical_english_content.json`
- App resource copy: `MedicalEnglishPronunciation/MedicalEnglishPronunciation/Resources/medical_english_content.json`

## Current Extraction Result

- Core vocabulary entries extracted from正文: 513
- Literature articles extracted: 199
- Literature structure: article -> paragraph -> English abstract -> Chinese translation -> inline vocabulary where available

## Known Gaps

- The vocabulary PDF cover advertises 517 entries, but extracted正文 jumps over these four numbers:
  - 221
  - 222
  - 266
  - 267
- Manual page inspection showed page 165 ends at entry 220 and page 166 starts at entry 223; page 194 ends at entry 265 and page 195 starts at entry 268.
- These four entries are not synthesized into the app data because no authoritative English/IPA/Chinese正文 was found in the extracted PDF text.

## Content Notes

- Watermark artifacts from the literature PDFs are partially cleaned during extraction.
- Long literature abstracts are stored as one paragraph per article in the first version. This preserves English/Chinese correspondence at article level and can be refined into smaller paragraph pairs later.
