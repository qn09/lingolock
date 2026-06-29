import Foundation
import Combine
import WidgetKit

public class AppSettings: ObservableObject {
    public static let shared = AppSettings()
    
    // Replace with your actual App Group identifier configured in Apple Developer Portal
    public static let appGroupId = "group.com.language.wordoftheday"
    
    public let sharedDefaults: UserDefaults?
    
    @Published public var selectedLanguage: String {
        didSet {
            sharedDefaults?.set(selectedLanguage, forKey: Keys.selectedLanguage)
            WidgetRefresher.refresh()
        }
    }
    
    @Published public var favoritedWordIds: Set<String> {
        didSet {
            let array = Array(favoritedWordIds)
            sharedDefaults?.set(array, forKey: Keys.favoritedWords)
        }
    }
    
    @Published public var geminiApiKey: String {
        didSet {
            sharedDefaults?.set(geminiApiKey, forKey: Keys.geminiApiKey)
        }
    }
    
    // Daily AI generated words cache, dictionary of date string to Word: [Language_YYYY-MM-DD : Word]
    @Published public var dailyAiWords: [String: Word] {
        didSet {
            if let encoded = try? JSONEncoder().encode(dailyAiWords) {
                sharedDefaults?.set(encoded, forKey: Keys.dailyAiWords)
            }
        }
    }
    
    // Global list of seen words to prevent duplicates
    @Published public var seenWordsList: [String] {
        didSet {
            sharedDefaults?.set(seenWordsList, forKey: Keys.seenWordsList)
        }
    }
    
    private enum Keys {
        static let selectedLanguage = "selected_language"
        static let favoritedWords = "favorited_words"
        static let geminiApiKey = "gemini_api_key"
        static let dailyAiWords = "daily_ai_words"
        static let seenWordsList = "seen_words_list"
    }
    
    private init() {
        self.sharedDefaults = UserDefaults(suiteName: AppSettings.appGroupId)
        
        // Load selected language, default to "English" if not set
        self.selectedLanguage = sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "English"
        
        // Load gemini API key, falling back to build-time environment variable if no custom key is saved on-device
        let savedKey = sharedDefaults?.string(forKey: Keys.geminiApiKey) ?? ""
        if savedKey.isEmpty {
            self.geminiApiKey = Secrets.geminiApiKey
        } else {
            self.geminiApiKey = savedKey
        }
        
        // Load daily AI words cache
        if let data = sharedDefaults?.data(forKey: Keys.dailyAiWords),
           let cache = try? JSONDecoder().decode([String: Word].self, from: data) {
            self.dailyAiWords = cache
        } else {
            self.dailyAiWords = [:]
        }
        
        // Load seen words list
        self.seenWordsList = sharedDefaults?.stringArray(forKey: Keys.seenWordsList) ?? []
        
        // Load favorited word IDs
        if let favoritedArray = sharedDefaults?.stringArray(forKey: Keys.favoritedWords) {
            self.favoritedWordIds = Set(favoritedArray)
        } else {
            self.favoritedWordIds = []
        }
    }
    
    // MARK: - Helper Methods
    
    public func getDateKey(for date: Date, language: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return "\(language)_\(dateString)"
    }
    
    public func getSavedWord(for date: Date, language: String) -> Word? {
        let key = getDateKey(for: date, language: language)
        
        // Always read directly from sharedDefaults to get changes made by the other process
        if let defaults = sharedDefaults,
           let data = defaults.data(forKey: Keys.dailyAiWords),
           let cache = try? JSONDecoder().decode([String: Word].self, from: data) {
            // Keep in-memory cache synchronized asynchronously
            DispatchQueue.main.async {
                self.dailyAiWords = cache
            }
            return cache[key]
        }
        
        return dailyAiWords[key]
    }
    
    public func saveWord(_ word: Word, for date: Date, language: String) {
        let key = getDateKey(for: date, language: language)
        
        // 1. Synchronously save to UserDefaults immediately to prevent data loss in short-lived extensions
        if let defaults = sharedDefaults {
            var currentCache: [String: Word] = [:]
            if let data = defaults.data(forKey: Keys.dailyAiWords),
               let cache = try? JSONDecoder().decode([String: Word].self, from: data) {
                currentCache = cache
            }
            currentCache[key] = word
            
            if let encoded = try? JSONEncoder().encode(currentCache) {
                defaults.set(encoded, forKey: Keys.dailyAiWords)
            }
            
            var currentSeen = defaults.stringArray(forKey: Keys.seenWordsList) ?? []
            let lowerWord = word.foreignWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if !currentSeen.contains(lowerWord) {
                currentSeen.append(lowerWord)
                defaults.set(currentSeen, forKey: Keys.seenWordsList)
            }
            
            defaults.synchronize()
        }
        
        // 2. Asynchronously update the @Published fields on the main thread for SwiftUI observers
        DispatchQueue.main.async {
            self.dailyAiWords[key] = word
            let lowerWord = word.foreignWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if !self.seenWordsList.contains(lowerWord) {
                self.seenWordsList.append(lowerWord)
            }
            WidgetRefresher.refresh()
        }
    }
    
    public func isFavorited(_ word: Word) -> Bool {
        return favoritedWordIds.contains(word.id.uuidString)
    }
    
    public func toggleFavorite(_ word: Word) {
        let idString = word.id.uuidString
        if favoritedWordIds.contains(idString) {
            favoritedWordIds.remove(idString)
        } else {
            favoritedWordIds.insert(idString)
        }
    }
}

// Helper to notify the OS to reload the widgets when settings change
public struct WidgetRefresher {
    public static func refresh() {
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}
