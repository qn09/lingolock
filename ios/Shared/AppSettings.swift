import Foundation
import Combine

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
    
    private enum Keys {
        static let selectedLanguage = "selected_language"
        static let favoritedWords = "favorited_words"
    }
    
    private init() {
        self.sharedDefaults = UserDefaults(suiteName: AppSettings.appGroupId)
        
        // Load selected language, default to "Spanish" if not set
        self.selectedLanguage = sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "Spanish"
        
        // Load favorited word IDs
        if let favoritedArray = sharedDefaults?.stringArray(forKey: Keys.favoritedWords) {
            self.favoritedWordIds = Set(favoritedArray)
        } else {
            self.favoritedWordIds = []
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
import WidgetKit
public struct WidgetRefresher {
    public static func refresh() {
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
}
