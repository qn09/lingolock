import Foundation

public struct Word: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let foreignWord: String
    public let translation: String // Legacy field. Prefer nativeMeaning/englishMeaning for new data.
    public let pronunciation: String // Japanese kana for Japanese words, phonetic spelling for other languages.
    public let romanization: String // Latin transcription for Japanese when needed.
    public let partOfSpeech: String // e.g., "noun", "verb", "adjective"
    public let meaning: String // Legacy field. Prefer nativeMeaning for learner-facing meaning.
    public let nativeMeaning: String // Meaning in the learner's native language, currently Vietnamese.
    public let englishMeaning: String // English gloss/meaning when useful, especially for Japanese.
    public let exampleForeign: String // Example sentence in target language
    public let exampleTranslation: String // Example sentence translated to Vietnamese.
    public let language: String // e.g., "English", "Japanese"
    public let level: String // e.g., "beginner", "intermediate", "advanced"
    public let tags: [String] // e.g., ["daily-life", "verb"]

    public var formattedPronunciation: String {
        let trimmed = pronunciation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        var clean = trimmed
        if clean.hasPrefix("/") { clean.removeFirst() }
        if clean.hasSuffix("/") { clean.removeLast() }
        return "/ \(clean.trimmingCharacters(in: .whitespaces)) /"
    }

    public var displayPronunciation: String {
        let trimmed = pronunciation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        if language == "Japanese" {
            return containsJapaneseScript(trimmed) ? trimmed : ""
        }

        return formattedPronunciation
    }

    public var displayTranslation: String {
        if language == "Japanese" {
            let english = displayEnglishMeaning
            if !english.isEmpty { return english }
        }

        let native = nativeMeaning.trimmingCharacters(in: .whitespacesAndNewlines)
        if !native.isEmpty { return native }

        let legacyMeaning = meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        if language == "Japanese", !legacyMeaning.isEmpty { return legacyMeaning }

        let legacyTranslation = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        if !legacyTranslation.isEmpty { return legacyTranslation }

        return legacyMeaning
    }

    public var displayMeaning: String {
        if language == "Japanese" {
            let english = displayEnglishMeaning
            if !english.isEmpty { return english }
        }

        let native = nativeMeaning.trimmingCharacters(in: .whitespacesAndNewlines)
        if !native.isEmpty { return native }

        let legacyMeaning = meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        if !legacyMeaning.isEmpty { return legacyMeaning }

        return translation.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var displayEnglishMeaning: String {
        let english = englishMeaning.trimmingCharacters(in: .whitespacesAndNewlines)
        if !english.isEmpty { return english }

        if language == "Japanese" {
            return translation.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return ""
    }

    public init(id: String = UUID().uuidString,
                foreignWord: String,
                translation: String = "",
                pronunciation: String,
                romanization: String = "",
                partOfSpeech: String,
                meaning: String,
                exampleForeign: String,
                language: String,
                nativeMeaning: String = "",
                englishMeaning: String = "",
                exampleTranslation: String = "",
                level: String = "beginner",
                tags: [String] = []) {
        self.id = id
        self.foreignWord = foreignWord
        self.translation = translation
        self.pronunciation = pronunciation
        self.romanization = romanization
        self.partOfSpeech = partOfSpeech
        self.meaning = meaning
        if nativeMeaning.isEmpty {
            self.nativeMeaning = language == "Japanese" ? meaning : translation
        } else {
            self.nativeMeaning = nativeMeaning
        }
        if englishMeaning.isEmpty {
            self.englishMeaning = language == "Japanese" ? translation : ""
        } else {
            self.englishMeaning = englishMeaning
        }
        self.exampleForeign = exampleForeign
        self.exampleTranslation = exampleTranslation
        self.language = language
        self.level = level
        self.tags = tags
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case foreignWord
        case translation
        case pronunciation
        case romanization
        case partOfSpeech
        case meaning
        case nativeMeaning
        case englishMeaning
        case exampleForeign
        case exampleTranslation
        case language
        case level
        case tags
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        let foreignWord = try container.decodeIfPresent(String.self, forKey: .foreignWord) ?? ""
        let translation = try container.decodeIfPresent(String.self, forKey: .translation) ?? ""
        let pronunciation = try container.decodeIfPresent(String.self, forKey: .pronunciation) ?? ""
        let romanization = try container.decodeIfPresent(String.self, forKey: .romanization) ?? ""
        let partOfSpeech = try container.decodeIfPresent(String.self, forKey: .partOfSpeech) ?? "noun"
        let meaning = try container.decodeIfPresent(String.self, forKey: .meaning) ?? ""
        let language = try container.decodeIfPresent(String.self, forKey: .language) ?? "English"

        self.init(
            id: id,
            foreignWord: foreignWord,
            translation: translation,
            pronunciation: pronunciation,
            romanization: romanization,
            partOfSpeech: partOfSpeech,
            meaning: meaning,
            exampleForeign: try container.decodeIfPresent(String.self, forKey: .exampleForeign) ?? "",
            language: language,
            nativeMeaning: try container.decodeIfPresent(String.self, forKey: .nativeMeaning) ?? "",
            englishMeaning: try container.decodeIfPresent(String.self, forKey: .englishMeaning) ?? "",
            exampleTranslation: try container.decodeIfPresent(String.self, forKey: .exampleTranslation) ?? "",
            level: try container.decodeIfPresent(String.self, forKey: .level) ?? "beginner",
            tags: try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        )
    }

    private func containsJapaneseScript(_ text: String) -> Bool {
        text.unicodeScalars.contains { scalar in
            (0x3040...0x309F).contains(Int(scalar.value)) ||
            (0x30A0...0x30FF).contains(Int(scalar.value)) ||
            (0x3400...0x9FFF).contains(Int(scalar.value))
        }
    }
}
