# 医学英语发音 Web App

基于三个 PDF 的医学英语发音学习 App。项目起初为 iOS 应用，现已全面转为 **Vue 3 + Vite 网页端应用**。

## 当前内容

- 核心词汇：已从 `参考文件/内分泌科复试核心词汇表.pdf` 提取 513 个正文词条。
- 文献学习：已从两份文献翻译合集提取 199 篇文章。
- 网页端资源文件存放于：`web/public/data/medical_english_content.json`（如果在构建过程中被移动，请参考对应的 Vue 组件使用路径）
- 数据质量说明：`content/DATA_QUALITY_REPORT.md`

## 重新生成内容数据

使用 Python 脚本解析 PDF（需要安装 pdfplumber 等依赖）：

```powershell
$env:PYTHONIOENCODING='utf-8'
python tools/extract_content.py
```

## 运行 Web 网页端

项目主工程目前位于 `web/` 目录下：

```powershell
cd web
npm install
npm run dev
```

## 遗留 iOS 工程

最初建立的 iOS 工程仍然保留在 `MedicalEnglishPronunciation/` 目录下（暂不删除作为参考）。但当前开发重点及功能验证均在 `web/` 目录下进行。
