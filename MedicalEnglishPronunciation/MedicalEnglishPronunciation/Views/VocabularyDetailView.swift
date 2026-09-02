import SwiftUI

struct VocabularyDetailView: View {
    let entry: VocabularyEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.english)
                        .font(.largeTitle.weight(.bold))
                    Text(entry.ipa)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text(entry.chinese)
                        .font(.title3.weight(.semibold))
                }

                SpeakButton(text: entry.english, label: "播放单词")

                if !entry.definition.isEmpty {
                    StudySection(title: "中文释义", text: entry.definition)
                }

                if !entry.exampleEnglish.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("双语例句")
                            .font(.headline)
                        Text(entry.exampleEnglish)
                            .font(.body)
                        SpeakButton(text: entry.exampleEnglish, label: "播放例句")
                        if !entry.exampleChinese.isEmpty {
                            Text(entry.exampleChinese)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("单词详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudySection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.body)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
