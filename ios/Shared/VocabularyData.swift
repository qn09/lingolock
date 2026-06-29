import Foundation
import FirebaseFirestore

public struct VocabularyData {
    public static let languages = ["English", "Japanese"]
    
    private static var isFetching = false

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
        
        let db = Firestore.firestore()
        db.collection("words").whereField("language", isEqualTo: language).getDocuments { snapshot, error in
            defer { 
                DispatchQueue.main.async { isFetching = false }
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No words found in Firebase for language: \(language)")
                return
            }
            
            // If forceRandom is true, pick a random word. Otherwise use date-based hashing to pick the same word today.
            let index: Int
            if forceRandom {
                index = Int.random(in: 0..<documents.count)
            } else {
                let calendar = Calendar.current
                let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
                index = (dayOfYear - 1) % documents.count
            }
            
            let doc = documents[index].data()
            let word = Word(
                id: documents[index].documentID,
                foreignWord: doc["foreignWord"] as? String ?? "",
                translation: doc["translation"] as? String ?? "",
                pronunciation: doc["pronunciation"] as? String ?? "",
                partOfSpeech: doc["partOfSpeech"] as? String ?? "noun",
                meaning: doc["meaning"] as? String ?? "",
                exampleForeign: doc["exampleForeign"] as? String ?? "",
                language: language
            )
            
            DispatchQueue.main.async {
                AppSettings.shared.saveWord(word, for: date, language: language)
            }
        }
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
