import Foundation

public struct Word: Codable, Identifiable, Hashable {
    public let id: UUID
    public let foreignWord: String
    public let translation: String
    public let pronunciation: String // Phonetic spelling or transcription
    public let partOfSpeech: String // e.g., "noun", "verb", "adjective"
    public let meaning: String // Detailed explanation
    public let exampleForeign: String // Example sentence in target language
    public let exampleTranslation: String // Example sentence translated
    public let language: String // e.g., "Spanish", "French", "Japanese", "German"
    
    public init(id: UUID = UUID(),
                foreignWord: String,
                translation: String,
                pronunciation: String,
                partOfSpeech: String,
                meaning: String,
                exampleForeign: String,
                exampleTranslation: String,
                language: String) {
        self.id = id
        self.foreignWord = foreignWord
        self.translation = translation
        self.pronunciation = pronunciation
        self.partOfSpeech = partOfSpeech
        self.meaning = meaning
        self.exampleForeign = exampleForeign
        self.exampleTranslation = exampleTranslation
        self.language = language
    }
}
