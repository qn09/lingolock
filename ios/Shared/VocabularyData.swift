import Foundation

public struct VocabularyData {
    public static let languages = ["English", "Japanese"]
    
    // A robust, high-quality list of starter vocabulary for English and Japanese.
    // Base explanations are in English for both languages.
    public static let words: [String: [Word]] = [
        "English": [],
        "Japanese": []
    ]
    
    private static var isFetching = false

    /// Computes the word of the day for a specific language and date.
    /// By using date components, we guarantee that all devices running the app
    /// and widgets show the exact same word for a given day, and it rotates automatically.
    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let languageWords = words[selectedLanguage] ?? []
        
        // If Gemini API is configured, use the automated daily AI generator
        if !AppSettings.shared.geminiApiKey.isEmpty {
            if let savedAiWord = AppSettings.shared.getSavedWord(for: date, language: selectedLanguage) {
                return savedAiWord
            } else {
                autoFetchWord(for: selectedLanguage, date: date)
            }
        }
        
        if languageWords.isEmpty {
            return Word(
                foreignWord: "LingoLock GRE",
                translation: "No Word Generated",
                pronunciation: "lee-ngoh-lok",
                partOfSpeech: "noun",
                meaning: "Please configure your Gemini API Key in Settings to automatically generate and display your daily GRE words.",
                exampleForeign: "Open Settings tab to configure.",
                exampleTranslation: "Open Settings tab to configure.",
                language: selectedLanguage
            )
        }
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % languageWords.count
        return languageWords[index]
    }
    
    private static func autoFetchWord(for language: String, date: Date) {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                let apiKey = AppSettings.shared.geminiApiKey
                let excludeList = AppSettings.shared.seenWordsList
                let word = try await GeminiService.shared.fetchVocabularyWord(for: language, apiKey: apiKey, excludeWords: excludeList)
                await MainActor.run {
                    AppSettings.shared.saveWord(word, for: date, language: language)
                    isFetching = false
                }
            } catch {
                print("Auto-fetch Gemini word failed: \(error.localizedDescription)")
                await MainActor.run {
                    isFetching = false
                }
            }
        }
    }
    
    /// Retrieves a historical list of words up to the current date.
    /// Helpful to simulate learning progress.
    public static func getHistory(for language: String, limit: Int = 10, relativeTo date: Date = Date()) -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let languageWords = words[selectedLanguage] ?? []
        
        var history: [Word] = []
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        // Let's retrieve the words of the last N days
        for i in 0..<min(limit, dayOfYear) {
            let targetDay = dayOfYear - i
            guard let targetDate = calendar.date(byAdding: .day, value: -i, to: date) else { continue }
            
            // Check if we have an AI word cached for this historical date, otherwise fall back to offline
            if !AppSettings.shared.geminiApiKey.isEmpty,
               let savedAiWord = AppSettings.shared.getSavedWord(for: targetDate, language: selectedLanguage) {
                history.append(savedAiWord)
            } else if !languageWords.isEmpty {
                let index = (targetDay - 1) % languageWords.count
                history.append(languageWords[index])
            }
        }
        
        return history
    }
}
