# PROJECT_STATE

- Project name: 医学英语发音 Web App
- Project type: code-development
- User goal: 基于三个已上传 PDF 构建医学英语发音学习软件，网页端，支持核心词汇、文献学习和发音练习。
- Expected deliverables: 结构化词汇与文献数据、Vue 3 网页端 App（首页、核心词汇、文献学习、发音练习、原生发音播放）。
- Current phase: 转型决策完成，开始搭建 Vue 3 + Vite 网页端工程
- Current focus: 创建 web/ 目录，搭建 Vue 3 + Vite 骨架，实现六个视图页面
- Important constraints: P0 只做必要功能；第一版不做 AI 发音评分；内容必须尽量对应 PDF 原文；单词和英文句子均需可播放发音；每次更改须在 .codex-pm 日志中追加操作记录。
- Key assumptions: 项目类型为网页端开发；PDF 原始文件位于 `参考文件/`；优先使用浏览器原生 Web Speech API 实现发音；部署阶段可切换 Google TTS。
- Relevant files: `tools/extract_content.py`; `content/medical_english_content.json`; `content/DATA_QUALITY_REPORT.md`; `web/` (待创建)
- Next actions: 创建 web/ Vue 3 + Vite 工程；实现首页、词汇、文献、发音练习六个页面；封装 Web Speech API；npm run build 验证。
- Last updated: 2026-09-02
