import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var contentStore: ContentStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("医学英语发音")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.primary)

                    if let errorMessage = contentStore.errorMessage {
                        Text(errorMessage)
                            .font(.body)
                            .foregroundStyle(.red)
                    }

                    VStack(spacing: 12) {
                        HomeLink(
                            title: "核心词汇",
                            subtitle: "\(contentStore.vocabulary.count) 个内分泌复试核心词条",
                            systemImage: "text.book.closed.fill",
                            tint: .teal,
                            destination: VocabularyListView()
                        )

                        HomeLink(
                            title: "文献学习",
                            subtitle: "\(contentStore.literature.count) 篇医学文献原文与中文翻译",
                            systemImage: "doc.text.magnifyingglass",
                            tint: .indigo,
                            destination: LiteratureListView()
                        )

                        HomeLink(
                            title: "发音练习",
                            subtitle: "单词与医学英语句子自测",
                            systemImage: "waveform.circle.fill",
                            tint: .mint,
                            destination: PronunciationPracticeView()
                        )
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

private struct HomeLink<Destination: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(tint, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
