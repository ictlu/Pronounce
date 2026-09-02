# PROJECT_STATE

- Project name: 医学英语发音 iOS App
- Project type: code-development
- User goal: 基于三个已上传 PDF 构建医学英语发音学习软件，采用 PDF 内容解析到结构化数据再进入 SwiftUI App 的方式，不把 PDF 直接嵌入为阅读器。
- Expected deliverables: 结构化词汇与文献数据、SwiftUI iOS App 首页、核心词汇、文献学习、发音练习、原生英语发音播放与基本播放状态。
- Current phase: 阶段 1 内容工程初版完成 + 阶段 2/3 P0 工程骨架完成初版
- Current focus: 在 macOS/Xcode 上构建验证 SwiftUI App，并继续校对 PDF 结构化内容质量。
- Important constraints: P0 只做必要功能；第一版不做 AI 发音评分；内容必须尽量对应 PDF 原文；单词和英文句子均需可播放发音。
- Key assumptions: 项目类型按最终交付物归类为 iOS 代码开发；PDF 原始文件位于 `参考文件/`；优先使用 iOS 原生 AVSpeechSynthesizer 实现发音。
- Relevant files: `tools/extract_content.py`; `content/medical_english_content.json`; `content/DATA_QUALITY_REPORT.md`; `MedicalEnglishPronunciation/MedicalEnglishPronunciation.xcodeproj`; `MedicalEnglishPronunciation/MedicalEnglishPronunciation/`
- Next actions: 在 macOS/Xcode 运行构建；检查首页、核心词汇、文献阅读、发音练习导航；实机或模拟器验证 AVSpeechSynthesizer 发音；继续人工校对 4 个缺号词条和文献段落拆分。
- Last updated: 2026-08-31
