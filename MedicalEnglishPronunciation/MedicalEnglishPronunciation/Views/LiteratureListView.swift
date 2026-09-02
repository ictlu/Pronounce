import SwiftUI

struct LiteratureListView: View {
    @EnvironmentObject private var contentStore: ContentStore
    @State private var query = ""

    private var filteredArticles: [LiteratureArticle] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return contentStore.literature
        }
        return contentStore.literature.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.titleChinese.localizedCaseInsensitiveContains(query) ||
            $0.topic.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List(filteredArticles) { article in
            NavigationLink(value: article) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(article.topic)
                        .font(.caption)
                        .foregroundStyle(.teal)
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(3)
                    Text(article.titleChinese)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    if !article.journal.isEmpty {
                        Text([article.journal, article.year].filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("文献学习")
        .searchable(text: $query, prompt: "搜索标题或主题")
        .navigationDestination(for: LiteratureArticle.self) { article in
            ArticleReaderView(article: article)
        }
    }
}
