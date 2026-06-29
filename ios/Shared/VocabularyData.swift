import Foundation

public struct VocabularyData {
    public static let languages = ["English", "Japanese"]
    
    // A robust, high-quality list of starter vocabulary for English and Japanese.
    // Base explanations are in English for both languages.
    public static let words: [String: [Word]] = [
        "English": [
            Word(foreignWord: "laconic", translation: "brief / concise", pronunciation: "luh-KON-ik", partOfSpeech: "adjective",
                 meaning: "Using very few words; expressing much in few words.",
                 exampleForeign: "His laconic reply suggested he lacked interest in the proposal.", exampleTranslation: "His brief reply suggested he lacked interest in the proposal.", language: "English"),
            Word(foreignWord: "capricious", translation: "fickle / unpredictable", pronunciation: "kuh-PRISH-uhs", partOfSpeech: "adjective",
                 meaning: "Given to sudden and unaccountable changes of mood or behavior.",
                 exampleForeign: "The administration's capricious policies caused confusion among employees.", exampleTranslation: "The administration's unpredictable policies caused confusion among employees.", language: "English"),
            Word(foreignWord: "cacophony", translation: "harsh sound", pronunciation: "kuh-KOF-uh-nee", partOfSpeech: "noun",
                 meaning: "A harsh, discordant mixture of sounds.",
                 exampleForeign: "A cacophony of car horns and sirens filled the city streets.", exampleTranslation: "A harsh mixture of car horns and sirens filled the city streets.", language: "English"),
            Word(foreignWord: "loquacious", translation: "talkative", pronunciation: "loh-KWAY-shuhs", partOfSpeech: "adjective",
                 meaning: "Tending to talk a great deal; talkative.",
                 exampleForeign: "The loquacious host kept the guests entertained all evening.", exampleTranslation: "The talkative host kept the guests entertained all evening.", language: "English"),
            Word(foreignWord: "anomaly", translation: "deviation / abnormality", pronunciation: "uh-NOM-uh-lee", partOfSpeech: "noun",
                 meaning: "Something that deviates from what is standard, normal, or expected.",
                 exampleForeign: "The scientist explained that the unusual result was a statistical anomaly.", exampleTranslation: "The scientist explained that the unusual result was a statistical abnormality.", language: "English"),
            Word(foreignWord: "ephemeral", translation: "fleeting / transient", pronunciation: "ih-FEM-er-uhl", partOfSpeech: "adjective",
                 meaning: "Lasting for a very short time; transient.",
                 exampleForeign: "The beauty of the cherry blossoms is ephemeral.", exampleTranslation: "The beauty of the cherry blossoms is ephemeral.", language: "English"),
            Word(foreignWord: "equivocal", translation: "ambiguous / unclear", pronunciation: "ih-KWIV-uh-kuhl", partOfSpeech: "adjective",
                 meaning: "Open to more than one interpretation; ambiguous or undecided.",
                 exampleForeign: "The politician gave an equivocal answer to avoid taking a clear stance.", exampleTranslation: "The politician gave an ambiguous answer to avoid taking a clear stance.", language: "English")
        ],
        "Japanese": [
            Word(foreignWord: "Komorebi (木漏れ日)", translation: "sunlight through trees", pronunciation: "ko-mo-reh-bee", partOfSpeech: "noun",
                 meaning: "The sunlight that filters through the leaves of trees.",
                 exampleForeign: "森を歩くと、美しい木漏れ日が見られます。", exampleTranslation: "Walking through the forest, you can see beautiful sunlight filtering through trees.", language: "Japanese"),
            Word(foreignWord: "Kintsugi (金継ぎ)", translation: "golden pottery repair", pronunciation: "keen-tsoo-gee", partOfSpeech: "noun",
                 meaning: "The Japanese art of repairing broken pottery with lacquer dusted or mixed with powdered gold.",
                 exampleForeign: "金継ぎは、壊れたものに新しい命を吹き込みます。", exampleTranslation: "Kintsugi breathes new life into broken objects.", language: "Japanese"),
            Word(foreignWord: "Ikigai (生き甲斐)", translation: "a reason for being", pronunciation: "ee-kee-guy", partOfSpeech: "noun",
                 meaning: "A concept referring to something that gives a person a sense of purpose or a reason for living.",
                 exampleForeign: "私の生き甲斐は、人々の役に立つことです。", exampleTranslation: "My reason for being is to be useful to people.", language: "Japanese"),
            Word(foreignWord: "Kaizen (改善)", translation: "continuous improvement", pronunciation: "kye-zen", partOfSpeech: "noun",
                 meaning: "A Japanese philosophy of continuous improvement of working practices and personal efficiency.",
                 exampleForeign: "毎日少しずつ業務を改善していきます。", exampleTranslation: "We will improve our business operations little by little every day.", language: "Japanese"),
            Word(foreignWord: "Natsukashii (懐かしい)", translation: "nostalgic / dear", pronunciation: "nah-tsoo-kah-shee", partOfSpeech: "adjective",
                 meaning: "Bringing back fond memories of the past; nostalgic.",
                 exampleForeign: "この古いアルバムを見ると、子供の頃が懐かしいです。", exampleTranslation: "Looking at this old album makes me feel nostalgic for my childhood.", language: "Japanese"),
            Word(foreignWord: "Shinrinyoku (森林浴)", translation: "forest bathing", pronunciation: "sheen-reen-yo-koo", partOfSpeech: "noun",
                 meaning: "The practice of spending therapeutic time in a forest, absorbing its atmosphere.",
                 exampleForeign: "週末は森に行って森林浴を楽しんでいます。", exampleTranslation: "I go to the forest on weekends to enjoy forest bathing.", language: "Japanese"),
            Word(foreignWord: "Yūgen (幽玄)", translation: "profound grace / mystery", pronunciation: "yoo-gen", partOfSpeech: "noun",
                 meaning: "A profound, mysterious sense of beauty in traditional Japanese aesthetics.",
                 exampleForeign: "この日本庭園には幽玄の美があります。", exampleTranslation: "This Japanese garden has a profound, mysterious beauty.", language: "Japanese")
        ]
    ]
    
    private static var isFetching = false

    /// Computes the word of the day for a specific language and date.
    /// By using date components, we guarantee that all devices running the app
    /// and widgets show the exact same word for a given day, and it rotates automatically.
    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let languageWords = words[selectedLanguage] ?? words["English"]!
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % languageWords.count
        let fallbackWord = languageWords[index]
        
        // If Gemini API is configured, use the automated daily AI generator
        if !AppSettings.shared.geminiApiKey.isEmpty {
            if let savedAiWord = AppSettings.shared.getSavedWord(for: date, language: selectedLanguage) {
                return savedAiWord
            } else {
                autoFetchWord(for: selectedLanguage, date: date)
            }
        }
        
        return fallbackWord
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
        let languageWords = words[selectedLanguage] ?? words["English"]!
        
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
            } else {
                let index = (targetDay - 1) % languageWords.count
                history.append(languageWords[index])
            }
        }
        
        return history
    }
}
