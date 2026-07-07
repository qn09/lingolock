import Foundation
#if canImport(Combine)
import Combine
#else
@propertyWrapper
public struct Published<Value> {
    public var wrappedValue: Value
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
public protocol ObservableObject: AnyObject {}
#endif

#if canImport(WidgetKit)
import WidgetKit
#endif

public class AppSettings: ObservableObject, @unchecked Sendable {
    public static let shared = AppSettings()
    private var suppressDailyAiWordsSideEffects = false

    // Resolved at runtime to handle AltServer/AltStore rewriting of App Group IDs
    public static var appGroupId: String { AppGroupResolver.resolvedGroupId }

    public let sharedDefaults: UserDefaults?

    @Published public var selectedLanguage: String {
        didSet {
            sharedDefaults?.set(selectedLanguage, forKey: Keys.selectedLanguage)
            sharedDefaults?.synchronize()

            // Pre-fetch the word of the day for the new language immediately
            // so it gets saved to defaults and is ready for the widget
            _ = VocabularyData.getWordOfTheDay(for: selectedLanguage)

            WidgetRefresher.refresh()
        }
    }

    @Published public var favoritedWordIds: Set<String> {
        didSet {
            let array = Array(favoritedWordIds)
            sharedDefaults?.set(array, forKey: Keys.favoritedWords)
            sharedDefaults?.synchronize()
        }
    }

    // Daily AI generated words cache, dictionary of date string to Word: [Language_YYYY-MM-DD : Word]
    @Published public var dailyAiWords: [String: Word] {
        didSet {
            guard !suppressDailyAiWordsSideEffects else { return }
            if let encoded = try? JSONEncoder().encode(dailyAiWords) {
                sharedDefaults?.set(encoded, forKey: Keys.dailyAiWords)
                sharedDefaults?.synchronize()
                WidgetRefresher.refresh()
            }
        }
    }

    // Global list of seen words to prevent duplicates
    @Published public var seenWordsList: [String] {
        didSet {
            sharedDefaults?.set(seenWordsList, forKey: Keys.seenWordsList)
            sharedDefaults?.synchronize()
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
        self.sharedDefaults = AppGroupResolver.sharedDefaults

        // Load selected language, default to "English" if not set
        self.selectedLanguage = sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "English"

        // Load daily AI words cache (now used for Firebase words)
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
                guard self.dailyAiWords != cache else { return }
                self.suppressDailyAiWordsSideEffects = true
                self.dailyAiWords = cache
                self.suppressDailyAiWordsSideEffects = false
            }
            return cache[key]
        }

        return dailyAiWords[key]
    }

    public func saveWord(_ word: Word, for date: Date, language: String, notifyWidgets: Bool = true) {
        saveWords([(word: word, date: date, language: language)], notifyWidgets: notifyWidgets)
    }

    public func saveWords(_ entries: [(word: Word, date: Date, language: String)], notifyWidgets: Bool = true) {
        guard !entries.isEmpty else { return }

        var updatedCache: [String: Word]
        var updatedSeen: [String]

        if let defaults = sharedDefaults {
            (updatedCache, updatedSeen) = loadPersistedVocabularyState(from: defaults)
            apply(entries, to: &updatedCache, seenWords: &updatedSeen)
            persistVocabularyState(cache: updatedCache, seenWords: updatedSeen, to: defaults)
        } else {
            updatedCache = dailyAiWords
            updatedSeen = seenWordsList
            apply(entries, to: &updatedCache, seenWords: &updatedSeen)
        }

        DispatchQueue.main.async {
            self.suppressDailyAiWordsSideEffects = true
            self.dailyAiWords = updatedCache
            self.suppressDailyAiWordsSideEffects = false
            self.seenWordsList = updatedSeen

            if notifyWidgets {
                WidgetRefresher.refresh()
            }
        }
    }

    private func loadPersistedVocabularyState(from defaults: UserDefaults) -> ([String: Word], [String]) {
        let cache: [String: Word]
        if let data = defaults.data(forKey: Keys.dailyAiWords),
           let decodedCache = try? JSONDecoder().decode([String: Word].self, from: data) {
            cache = decodedCache
        } else {
            cache = [:]
        }

        return (cache, defaults.stringArray(forKey: Keys.seenWordsList) ?? [])
    }

    private func persistVocabularyState(cache: [String: Word], seenWords: [String], to defaults: UserDefaults) {
        if let encoded = try? JSONEncoder().encode(cache) {
            defaults.set(encoded, forKey: Keys.dailyAiWords)
        }
        defaults.set(seenWords, forKey: Keys.seenWordsList)
        defaults.synchronize()
    }

    private func apply(
        _ entries: [(word: Word, date: Date, language: String)],
        to cache: inout [String: Word],
        seenWords: inout [String]
    ) {
        for entry in entries {
            let key = getDateKey(for: entry.date, language: entry.language)
            cache[key] = entry.word

            let lowerWord = entry.word.foreignWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if !seenWords.contains(lowerWord) {
                seenWords.append(lowerWord)
            }
        }
    }

    public func isFavorited(_ word: Word) -> Bool {
        return favoritedWordIds.contains(word.id)
    }

    public func toggleFavorite(_ word: Word) {
        let idString = word.id
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
