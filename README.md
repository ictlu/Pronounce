# 医学英语发音 iOS App

基于三个 PDF 的医学英语发音学习 App。第一版采用“PDF -> 结构化 JSON -> SwiftUI App”的内容流，不把 PDF 直接嵌入为阅读器。

## 当前内容

- 核心词汇：已从 `参考文件/内分泌科复试核心词汇表.pdf` 提取 513 个正文词条。
- 文献学习：已从两份文献翻译合集提取 199 篇文章。
- App 资源：`MedicalEnglishPronunciation/MedicalEnglishPronunciation/Resources/medical_english_content.json`
- 数据质量说明：`content/DATA_QUALITY_REPORT.md`

## 重新生成内容数据

使用 Codex runtime Python：

```powershell
$env:PYTHONIOENCODING='utf-8'
& 'C:\Users\ictlu\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' tools/extract_content.py
```

脚本会同时写入：

- `content/medical_english_content.json`
- `MedicalEnglishPronunciation/MedicalEnglishPronunciation/Resources/medical_english_content.json`

## 打开 iOS 工程

在 macOS 上使用 Xcode 打开：

```bash
open MedicalEnglishPronunciation/MedicalEnglishPronunciation.xcodeproj
```

当前工作环境是 Windows，不能运行 `xcodebuild` 或 iOS Simulator。需要在 macOS/Xcode 上完成最终构建验证。
