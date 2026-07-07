import Foundation

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
        fetchWordsFromFirebase(for: language, date: date, forceRandom: true)
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
        let projectId = "web1-d1df7"
        let urlString = "https://firestore.googleapis.com/v1/projects/\(projectId)/databases/(default)/documents:runQuery"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                
                var matchingDocs: [[String: Any]] = []
                for item in json {
                    if let doc = item["document"] as? [String: Any] {
                        matchingDocs.append(doc)
                    }
                }
                
                guard !matchingDocs.isEmpty else { return nil }
                
                let index: Int
                if forceRandom {
                    // Pick a random word. If we have the current word in UserDefaults, try to pick a different one if possible
                    var randomIndex = Int.random(in: 0..<matchingDocs.count)
                    
                    // Simple attempt to avoid same word if we have more than 1
                    if matchingDocs.count > 1 {
                        if let savedWord = AppSettings.shared.getSavedWord(for: date, language: language) {
                            for _ in 0..<5 {
                                let docName = matchingDocs[randomIndex]["name"] as? String ?? ""
                                let wordId = docName.components(separatedBy: "/").last ?? ""
                                if wordId != savedWord.id {
                                    break
                                }
                                randomIndex = Int.random(in: 0..<matchingDocs.count)
                            }
                        }
                    }
                    index = randomIndex
                } else {
                    let calendar = Calendar.current
                    let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
                    index = (dayOfYear - 1) % matchingDocs.count
                }
                
                let selectedDoc = matchingDocs[index]
                if let fields = selectedDoc["fields"] as? [String: Any] {
                    let docName = selectedDoc["name"] as? String ?? ""
                    let wordId = docName.components(separatedBy: "/").last ?? UUID().uuidString
                    
                    return Word(
                        id: wordId,
                        foreignWord: (fields["foreignWord"] as? [String: Any])?["stringValue"] as? String ?? "",
                        translation: (fields["translation"] as? [String: Any])?["stringValue"] as? String ?? "",
                        pronunciation: (fields["pronunciation"] as? [String: Any])?["stringValue"] as? String ?? "",
                        partOfSpeech: (fields["partOfSpeech"] as? [String: Any])?["stringValue"] as? String ?? "noun",
                        meaning: (fields["meaning"] as? [String: Any])?["stringValue"] as? String ?? "",
                        exampleForeign: (fields["exampleForeign"] as? [String: Any])?["stringValue"] as? String ?? "",
                        language: language
                    )
                }
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
}
