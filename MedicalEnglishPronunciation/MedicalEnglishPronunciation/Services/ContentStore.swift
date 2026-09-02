import Foundation

@MainActor
final class ContentStore: ObservableObject {
    @Published private(set) var content: MedicalContent?
    @Published private(set) var errorMessage: String?

    var vocabulary: [VocabularyEntry] {
        content?.vocabulary ?? []
    }

    var literature: [LiteratureArticle] {
        content?.literature ?? []
    }

    init() {
        load()
    }

    func load() {
        guard let url = Bundle.main.url(forResource: "medical_english_content", withExtension: "json") else {
            errorMessage = "未找到学习内容数据。"
            return
        }

        do {
            let data = try Data(contentsOf: url)
            content = try JSONDecoder().decode(MedicalContent.self, from: data)
            errorMessage = nil
        } catch {
            errorMessage = "学习内容读取失败：\(error.localizedDescription)"
        }
    }
}
