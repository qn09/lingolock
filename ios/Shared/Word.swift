import Foundation

public struct Word: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let foreignWord: String
    public let translation: String // Translation in native language (e.g. Japanese or English)
    public let pronunciation: String // Phonetic spelling or transcription
    public let partOfSpeech: String // e.g., "noun", "verb", "adjective"
    public let meaning: String // Detailed explanation
    public let exampleForeign: String // Example sentence in target language
    public let language: String // e.g., "English", "Japanese"
    
    public var formattedPronunciation: String {
        let trimmed = pronunciation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        var clean = trimmed
        if clean.hasPrefix("/") { clean.removeFirst() }
        if clean.hasSuffix("/") { clean.removeLast() }
        return "/ \(clean.trimmingCharacters(in: .whitespaces)) /"
    }
    
    public init(id: String = UUID().uuidString,
                foreignWord: String,
                translation: String = "",
                pronunciation: String,
                partOfSpeech: String,
                meaning: String,
                exampleForeign: String,
                language: String) {
        self.id = id
        self.foreignWord = foreignWord
        self.translation = translation
        self.pronunciation = pronunciation
        self.partOfSpeech = partOfSpeech
        self.meaning = meaning
        self.exampleForeign = exampleForeign
        self.language = language
    }
}
