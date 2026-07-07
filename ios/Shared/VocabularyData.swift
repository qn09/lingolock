import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct VocabularyData {
    public static let languages = ["English", "Japanese"]

    private nonisolated(unsafe) static var isFetching = false

    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "English"

        if let savedWord = AppSettings.shared.getSavedWord(for: date, language: selectedLanguage) {
            return savedWord
        }

        // Return a placeholder while we fetch from Firebase, or trigger fetch
        fetchWordsFromFirebase(for: selectedLanguage, date: date)

        return Word(
            foreignWord: "LingoLock \(selectedLanguage)",
            pronunciation: "...",
            partOfSpeech: "noun",
            meaning: "Fetching your vocabulary from the database. Please wait or make sure your internet is connected.",
            exampleForeign: "...",
            language: selectedLanguage
        )
    }

    public static func forceGenerateNewWord(for language: String, date: Date = Date()) {
        Task {
            _ = await generateNewWordAsync(for: language, date: date)
        }
    }

    @discardableResult
    public static func generateNewWordAsync(for language: String, date: Date = Date()) async -> Word? {
        let selectedLanguage = languages.contains(language) ? language : "English"
        guard let word = await fetchWordRESTAsync(for: selectedLanguage, date: date, forceRandom: true) else {
            return nil
        }

        AppSettings.shared.saveWord(word, for: date, language: selectedLanguage)
        return word
    }

    private static func fetchWordsFromFirebase(for language: String, date: Date, forceRandom: Bool = false) {
        guard !isFetching else { return }
        isFetching = true

        Task {
            defer {
                DispatchQueue.main.async { isFetching = false }
            }

            if let word = await fetchWordRESTAsync(for: language, date: date, forceRandom: forceRandom) {
                DispatchQueue.main.async {
                    AppSettings.shared.saveWord(word, for: date, language: language)
                }
            } else {
                print("Failed to fetch from REST API in fetchWordsFromFirebase")
            }
        }
    }

    public static func fetchWordRESTAsync(for language: String, date: Date, forceRandom: Bool = false) async -> Word? {
        let selectedLanguage = languages.contains(language) ? language : "English"
        guard let languageWords = await fetchWordsRESTAsync(for: selectedLanguage), !languageWords.isEmpty else {
            return nil
        }

        let index: Int
        if forceRandom {
            var randomIndex = Int.random(in: 0..<languageWords.count)
            if languageWords.count > 1,
               let savedWord = AppSettings.shared.getSavedWord(for: date, language: selectedLanguage) {
                let savedForeignWord = savedWord.foreignWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                for _ in 0..<20 {
                    let candidateForeignWord = languageWords[randomIndex].foreignWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    if languageWords[randomIndex].id != savedWord.id && candidateForeignWord != savedForeignWord {
                        break
                    }
                    randomIndex = Int.random(in: 0..<languageWords.count)
                }
            }
            index = randomIndex
        } else {
            index = wordIndex(for: date, wordCount: languageWords.count)
        }

        return languageWords[index]
    }

    public static func rebuildHistoryRESTAsync(for language: String, limit: Int = 30, relativeTo date: Date = Date()) async -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let historyLimit = min(limit, dayOfYear)

        var history: [Word] = []
        var missingEntries: [(word: Word, date: Date, language: String)] = []
        guard let languageWords = await fetchWordsRESTAsync(for: selectedLanguage), !languageWords.isEmpty else {
            return getHistory(for: selectedLanguage, limit: limit, relativeTo: date)
        }

        for i in 0..<historyLimit {
            guard let targetDate = calendar.date(byAdding: .day, value: -i, to: date) else { continue }
            if let savedWord = AppSettings.shared.getSavedWord(for: targetDate, language: selectedLanguage) {
                history.append(savedWord)
                continue
            }

            let word = languageWords[wordIndex(for: targetDate, wordCount: languageWords.count)]
            missingEntries.append((word: word, date: targetDate, language: selectedLanguage))
            history.append(word)
        }

        AppSettings.shared.saveWords(missingEntries, notifyWidgets: false)
        WidgetRefresher.refresh()
        return history
    }

    private static func fetchWordsRESTAsync(for language: String) async -> [Word]? {
        let projectId = "web1-d1df7"
        let urlString = "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents:runQuery"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let queryBody: [String: Any] = [
            "structuredQuery": [
                "from": [["collectionId": "words"]],
                "where": [
                    "fieldFilter": [
                        "field": ["fieldPath": "language"],
                        "op": "EQUAL",
                        "value": ["stringValue": language]
                    ]
                ]
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: queryBody)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                let words = json.compactMap { item -> Word? in
                    guard let doc = item["document"] as? [String: Any],
                          let fields = doc["fields"] as? [String: Any] else {
                        return nil
                    }
                    return word(from: doc, fields: fields, language: language)
                }
                return words.isEmpty ? nil : words
            }
        } catch {
            print("Error fetching REST: \(error)")
        }
        return nil
    }

    public static func getHistory(for language: String, limit: Int = 10, relativeTo date: Date = Date()) -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "English"
        var history: [Word] = []
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1

        for i in 0..<min(limit, dayOfYear) {
            guard let targetDate = calendar.date(byAdding: .day, value: -i, to: date) else { continue }
            if let savedWord = AppSettings.shared.getSavedWord(for: targetDate, language: selectedLanguage) {
                history.append(savedWord)
            }
        }

        return history
    }

    private static func wordIndex(for date: Date, wordCount: Int) -> Int {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        return (dayOfYear - 1) % wordCount
    }

    private static func word(from doc: [String: Any], fields: [String: Any], language: String) -> Word {
        let docName = doc["name"] as? String ?? ""
        let wordId = docName.components(separatedBy: "/").last ?? UUID().uuidString

        return Word(
            id: wordId,
            foreignWord: stringField("foreignWord", in: fields),
            translation: stringField("translation", in: fields),
            pronunciation: stringField("pronunciation", in: fields),
            romanization: stringField("romanization", in: fields),
            partOfSpeech: stringField("partOfSpeech", in: fields, defaultValue: "noun"),
            meaning: stringField("meaning", in: fields),
            exampleForeign: stringField("exampleForeign", in: fields),
            language: language,
            nativeMeaning: stringField("nativeMeaning", in: fields),
            englishMeaning: stringField("englishMeaning", in: fields),
            exampleTranslation: stringField("exampleTranslation", in: fields),
            level: stringField("level", in: fields, defaultValue: "beginner"),
            tags: stringArrayField("tags", in: fields)
        )
    }

    private static func stringField(_ name: String, in fields: [String: Any], defaultValue: String = "") -> String {
        (fields[name] as? [String: Any])?["stringValue"] as? String ?? defaultValue
    }

    private static func stringArrayField(_ name: String, in fields: [String: Any]) -> [String] {
        guard
            let field = fields[name] as? [String: Any],
            let arrayValue = field["arrayValue"] as? [String: Any],
            let values = arrayValue["values"] as? [[String: Any]]
        else {
            return []
        }

        return values.compactMap { $0["stringValue"] as? String }
    }
}
