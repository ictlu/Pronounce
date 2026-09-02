import Foundation

struct MedicalContent: Decodable {
    let metadata: ContentMetadata
    let vocabulary: [VocabularyEntry]
    let literature: [LiteratureArticle]
}

struct ContentMetadata: Decodable {
    let title: String
    let schemaVersion: Int
    let sourcePdfs: [String]
    let vocabularyCount: Int
    let articleCount: Int
}

struct VocabularyEntry: Decodable, Identifiable, Hashable {
    let id: String
    let english: String
    let ipa: String
    let chinese: String
    let definition: String
    let exampleEnglish: String
    let exampleChinese: String
    let frequency: String
    let sourcePdf: String
    let sourcePage: Int

    enum CodingKeys: String, CodingKey {
        case id
        case english
        case ipa
        case chinese
        case definition
        case exampleEnglish = "example_english"
        case exampleChinese = "example_chinese"
        case frequency
        case sourcePdf = "source_pdf"
        case sourcePage = "source_page"
    }
}

struct LiteratureArticle: Decodable, Identifiable, Hashable {
    let id: String
    let sourcePdf: String
    let category: String
    let topic: String
    let title: String
    let titleChinese: String
    let journal: String
    let year: String
    let paragraphs: [LiteratureParagraph]
    let vocabulary: [VocabularyEntry]
    let sourcePage: Int

    enum CodingKeys: String, CodingKey {
        case id
        case sourcePdf = "source_pdf"
        case category
        case topic
        case title
        case titleChinese = "title_chinese"
        case journal
        case year
        case paragraphs
        case vocabulary
        case sourcePage = "source_page"
    }
}

struct LiteratureParagraph: Decodable, Identifiable, Hashable {
    let id: String
    let english: String
    let chinese: String
    let vocabulary: [String]
}
