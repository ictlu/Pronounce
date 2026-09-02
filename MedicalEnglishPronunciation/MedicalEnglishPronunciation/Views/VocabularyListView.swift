import SwiftUI

struct VocabularyListView: View {
    @EnvironmentObject private var contentStore: ContentStore
    @State private var query = ""

    private var filteredVocabulary: [VocabularyEntry] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return contentStore.vocabulary
        }
        return contentStore.vocabulary.filter {
            $0.english.localizedCaseInsensitiveContains(query) ||
            $0.chinese.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List(filteredVocabulary) { entry in
            NavigationLink(value: entry) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(entry.english)
                            .font(.headline)
                        Spacer()
                        if !entry.frequency.isEmpty {
                            Text(entry.frequency)
                                .font(.caption)
                                .foregroundStyle(.teal)
                        }
                    }
                    Text(entry.ipa)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(entry.chinese)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("核心词汇")
        .searchable(text: $query, prompt: "搜索英文或中文")
        .navigationDestination(for: VocabularyEntry.self) { entry in
            VocabularyDetailView(entry: entry)
        }
    }
}
