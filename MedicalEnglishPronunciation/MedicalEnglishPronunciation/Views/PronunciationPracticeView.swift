import SwiftUI

struct PronunciationPracticeView: View {
    @EnvironmentObject private var contentStore: ContentStore

    private var practiceWords: [VocabularyEntry] {
        Array(contentStore.vocabulary.prefix(12))
    }

    private var practiceSentences: [String] {
        contentStore.vocabulary
            .compactMap { $0.exampleEnglish.isEmpty ? nil : $0.exampleEnglish }
            .prefix(8)
            .map { $0 }
    }

    var body: some View {
        List {
            Section("单词发音") {
                ForEach(practiceWords) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.english)
                                .font(.headline)
                            Text(entry.ipa)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(entry.chinese)
                                .font(.subheadline)
                        }
                        Spacer()
                        SpeakButton(text: entry.english, label: "听")
                            .labelStyle(.iconOnly)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("句子发音") {
                ForEach(Array(practiceSentences.enumerated()), id: \.offset) { _, sentence in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(sentence)
                            .font(.body)
                        SpeakButton(text: sentence, label: "播放句子")
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("发音练习")
    }
}
