import SwiftUI

struct ArticleReaderView: View {
    let article: LiteratureArticle
    @State private var showsTranslation = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.category)
                        .font(.caption)
                        .foregroundStyle(.teal)
                    Text(article.title)
                        .font(.title2.weight(.bold))
                    Text(article.titleChinese)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    if !article.journal.isEmpty {
                        Text([article.journal, article.year].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Toggle("显示中文翻译", isOn: $showsTranslation)
                    .toggleStyle(.switch)

                ForEach(article.paragraphs) { paragraph in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(paragraph.english)
                            .font(.body)
                            .lineSpacing(5)
                        SpeakButton(text: paragraph.english, label: "播放英文")
                        if showsTranslation {
                            Text(paragraph.chinese)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .lineSpacing(5)
                        }
                    }
                    .padding(.vertical, 8)
                }

                if !article.vocabulary.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("核心词汇")
                            .font(.headline)
                        ForEach(article.vocabulary.prefix(12)) { entry in
                            HStack(alignment: .firstTextBaseline) {
                                Text(entry.english)
                                    .font(.subheadline.weight(.semibold))
                                Text(entry.ipa)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(entry.chinese)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("文章")
        .navigationBarTitleDisplayMode(.inline)
    }
}
