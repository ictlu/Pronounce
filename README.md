# 医学英语发音 Web App (24k-pronounce)

本项目是一个专门用于医学英语发音学习和文献阅读的 Web 应用。最初设计为 iOS 应用，现已全面重构并部署为 **Vue 3 + Vite 现代前端单页应用 (SPA)**，搭配 **Supabase Serverless 后端**。

🌐 **线上访问地址**：[https://24k-pronounce.netlify.app/](https://24k-pronounce.netlify.app/)

## 🛠 技术栈与架构

*   **前端框架**：Vue 3 (Composition API) + Vite + Vue Router + Pinia
*   **后端服务**：[Supabase](https://supabase.com/) (PostgreSQL 数据库 + Edge Functions)
*   **发音引擎 (TTS)**：前端通过 Supabase Edge Function 中转直连 Microsoft Edge 的自然神经网络语音接口 (en-US-AriaNeural)，实现**免费、无限制、极其自然**的高质量流式秒发音。
*   **网站托管**：Netlify，完全自动化 CI/CD 部署。

## 📦 核心功能

*   **核心词汇 (513词)**：涵盖基础医学词汇，提供英音音标、中文释义、章节分类及发音。
*   **文献学习 (199篇)**：内嵌近两百篇医学文献，提供中英双语段落对照，重点词汇高亮，段落原声朗读。
*   **无感发音流**：利用后端 Edge TTS 代理和前台 Audio Streaming 结合，点击即播，延迟极低。

## 🚀 本地开发指南

### 1. 运行前端应用
前端项目位于 web/ 目录下。运行前请确保配置好 .env 文件。
`ash
cd web
npm install
npm run dev
`

**环境变量配置 (web/.env)**：
`env
VITE_SUPABASE_URL=您的Supabase项目地址
VITE_SUPABASE_ANON_KEY=您的Supabase_Anon_Key
`

### 2. 数据库说明 (Supabase)
本地开发的原始 JSON 数据位于 web/public/data/medical_english_content.json，现已全量迁移至 Supabase 云端的 PostgreSQL 数据库中。
主要拥有以下两张开启了 RLS（公共只读）的表：
*   core_vocabularies (核心词汇表)
*   literature_articles (文献段落表)

### 3. 云函数 (Edge Functions)
发音代理逻辑存放在 supabase/functions/tts/index.ts。
部署命令示例（需安装 Supabase CLI）：
`ash
supabase functions deploy tts --project-ref 您的项目ID --no-verify-jwt
`

## 📄 数据提取脚本 (历史遗留)

原始 PDF 解析脚本仍然保留在项目中以供参考：
`powershell
$env:PYTHONIOENCODING='utf-8'
python tools/extract_content.py
`

最初的 iOS 源码存放在 MedicalEnglishPronunciation/ 目录中，但已被当前架构取代。
