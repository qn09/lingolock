// --- VOCABULARY DATA (Matches Swift VocabularyData.words) ---
const vocabulary = {
    English: [
        { foreignWord: "serendipity", translation: "happy accident", pronunciation: "seh-ren-DIP-i-tee", partOfSpeech: "noun", meaning: "The occurrence and development of events by chance in a happy or beneficial way.", exampleForeign: "Meeting my old friend at the airport was pure serendipity.", exampleTranslation: "Meeting my old friend at the airport was pure serendipity.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "resilience", translation: "quick recovery", pronunciation: "ri-ZIL-yuns", partOfSpeech: "noun", meaning: "The capacity to recover quickly from difficulties; toughness.", exampleForeign: "She showed great resilience in overcoming her illness.", exampleTranslation: "She showed great resilience in overcoming her illness.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "ephemeral", translation: "fleeting / transient", pronunciation: "ih-FEM-er-uhl", partOfSpeech: "adjective", meaning: "Lasting for a very short time; transient.", exampleForeign: "The beauty of the cherry blossoms is ephemeral.", exampleTranslation: "The beauty of the cherry blossoms is ephemeral.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "eloquent", translation: "articulate / persuasive", pronunciation: "EL-uh-kwent", partOfSpeech: "adjective", meaning: "Fluent or persuasive in speaking or writing.", exampleForeign: "His eloquent speech moved the audience to tears.", exampleTranslation: "His eloquent speech moved the audience to tears.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "solitude", translation: "peaceful isolation", pronunciation: "SOL-i-tood", partOfSpeech: "noun", meaning: "The state or situation of being alone, especially in a peaceful and pleasant way.", exampleForeign: "She savored the quiet solitude of the early morning.", exampleTranslation: "She savored the quiet solitude of the early morning.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "meticulous", translation: "extremely precise", pronunciation: "muh-TIK-yuh-luhs", partOfSpeech: "adjective", meaning: "Showing great attention to detail; very careful and precise.", exampleForeign: "He was meticulous about keeping his records clean.", exampleTranslation: "He was meticulous about keeping his records clean.", bcp47: "en-US", flag: "🇬🇧" },
        { foreignWord: "ubiquitous", translation: "found everywhere", pronunciation: "yoo-BIK-wi-tuhs", partOfSpeech: "adjective", meaning: "Present, appearing, or found everywhere.", exampleForeign: "Smartphones have become ubiquitous in modern society.", exampleTranslation: "Smartphones have become ubiquitous in modern society.", bcp47: "en-US", flag: "🇬🇧" }
    ],
    Japanese: [
        { foreignWord: "Komorebi (木漏れ日)", translation: "sunlight through trees", pronunciation: "ko-mo-reh-bee", partOfSpeech: "noun", meaning: "The sunlight that filters through the leaves of trees.", exampleForeign: "森を歩くと、美しい木漏れ日が見られます。", exampleTranslation: "Walking through the forest, you can see beautiful sunlight filtering through trees.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Kintsugi (金継ぎ)", translation: "golden pottery repair", pronunciation: "keen-tsoo-gee", partOfSpeech: "noun", meaning: "The Japanese art of repairing broken pottery with lacquer dusted or mixed with powdered gold.", exampleForeign: "金継ぎは、壊れたものに新しい命を吹き込みます。", exampleTranslation: "Kintsugi breathes new life into broken objects.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Ikigai (生き甲斐)", translation: "a reason for being", pronunciation: "ee-kee-guy", partOfSpeech: "noun", meaning: "A concept referring to something that gives a person a sense of purpose or a reason for living.", exampleForeign: "私の生き甲斐は、人々の役に立つことです。", exampleTranslation: "My reason for being is to be useful to people.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Kaizen (改善)", translation: "continuous improvement", pronunciation: "kye-zen", partOfSpeech: "noun", meaning: "A Japanese philosophy of continuous improvement of working practices and personal efficiency.", exampleForeign: "毎日少しずつ業務を改善していきます。", exampleTranslation: "We will improve our business operations little by little every day.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Natsukashii (懐かしい)", translation: "nostalgic / dear", pronunciation: "nah-tsoo-kah-shee", partOfSpeech: "adjective", meaning: "Bringing back fond memories of the past; nostalgic.", exampleForeign: "この古いアルバムを見ると、子供の頃が懐かしいです。", exampleTranslation: "Looking at this old album makes me feel nostalgic for my childhood.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Shinrinyoku (森林浴)", translation: "forest bathing", pronunciation: "sheen-reen-yo-koo", partOfSpeech: "noun", meaning: "The practice of spending therapeutic time in a forest, absorbing its atmosphere.", exampleForeign: "週末は森に行って森林浴を楽しんでいます。", exampleTranslation: "I go to the forest on weekends to enjoy forest bathing.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Yūgen (幽玄)", translation: "profound grace / mystery", pronunciation: "yoo-gen", partOfSpeech: "noun", meaning: "A profound, mysterious sense of beauty in traditional Japanese aesthetics.", exampleForeign: "この日本庭園には幽玄の美があります。", exampleTranslation: "This Japanese garden has a profound, mysterious beauty.", bcp47: "ja-JP", flag: "🇯🇵" }
    ]
};

// --- SWIFT CODE STRINGS FOR CODE MODAL ---
const swiftCodes = {
    Word: `import Foundation

public struct Word: Codable, Identifiable, Hashable {
    public let id: UUID
    public let foreignWord: String
    public let translation: String
    public let pronunciation: String
    public let partOfSpeech: String
    public let meaning: String
    public let exampleForeign: String
    public let exampleTranslation: String
    public let language: String
    
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
}`,
    VocabularyData: `import Foundation

public struct VocabularyData {
    public static let languages = ["English", "Japanese"]
    
    public static let words: [String: [Word]] = [
        "English": [
            Word(foreignWord: "serendipity", translation: "happy accident", pronunciation: "seh-ren-DIP-i-tee", partOfSpeech: "noun", ...),
            Word(foreignWord: "resilience", translation: "quick recovery", pronunciation: "ri-ZIL-yuns", partOfSpeech: "noun", ...),
            // See Shared/VocabularyData.swift for complete dictionary entries
        ],
        "Japanese": [ ... ]
    ]
    
    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let languageWords = words[selectedLanguage] ?? words["English"]!
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % languageWords.count
        
        return languageWords[index]
    }
    
    public static func getHistory(for language: String, limit: Int = 10, relativeTo date: Date = Date()) -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "English"
        let languageWords = words[selectedLanguage] ?? words["English"]!
        
        var history: [Word] = []
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        for i in 0..<min(limit, dayOfYear) {
            let targetDay = dayOfYear - i
            let index = (targetDay - 1) % languageWords.count
            history.append(languageWords[index])
        }
        return history
    }
}`,
    AppSettings: `import Foundation
import Combine

public class AppSettings: ObservableObject {
    public static let shared = AppSettings()
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
            sharedDefaults?.set(Array(favoritedWordIds), forKey: Keys.favoritedWords)
        }
    }
    
    private init() {
        self.sharedDefaults = UserDefaults(suiteName: AppSettings.appGroupId)
        self.selectedLanguage = sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "English"
        self.favoritedWordIds = Set(sharedDefaults?.stringArray(forKey: Keys.favoritedWords) ?? [])
    }
    
    public func isFavorited(_ word: Word) -> Bool {
        favoritedWordIds.contains(word.id.uuidString)
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

import WidgetKit
public struct WidgetRefresher {
    public static func refresh() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}`,
    Widget: `import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // ... TimelineProvider standard callbacks: placeholder, getSnapshot
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let language = getSelectedLanguage()
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Pre-generates entries for 3 days to enable offline lock screen updates
        for dayOffset in 0..<3 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else { continue }
            let midnightDate = calendar.startOfDay(for: entryDate)
            let wordForDay = VocabularyData.getWordOfTheDay(for: language, date: midnightDate)
            
            let triggerDate = dayOffset == 0 ? currentDate : midnightDate
            entries.append(SimpleEntry(date: triggerDate, word: wordForDay))
        }

        let expiryDate = calendar.date(byAdding: .day, value: 3, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(expiryDate))
        completion(timeline)
    }
}

struct WordOfTheDayWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryInline:
            InlineWidgetView(word: entry.word)
        case .accessoryRectangular:
            RectangularWidgetView(word: entry.word)
        case .accessoryCircular:
            CircularWidgetView(word: entry.word)
        case .systemSmall:
            SmallWidgetView(word: entry.word)
        case .systemMedium:
            MediumWidgetView(word: entry.word)
        default:
            SmallWidgetView(word: entry.word)
        }
    }
}

// See WordOfTheDayWidget/WordOfTheDayWidget.swift for specific SwiftUI designs`
};

// --- SIMULATOR STATE ---
let selectedLanguage = "English";
let dateOffset = 0; // Days offset from today
let favorites = new Set();
let isPhoneLocked = true;
let activeTab = "learn";
let widgetStyle = "rectangular";

let geminiApiKey = localStorage.getItem("gemini_api_key") || "";
let geminiModel = localStorage.getItem("gemini_model") || "gemini-2.5-flash";

// Daily AI generated words cache, dictionary of date string to Word: [Language_YYYY-MM-DD : Word]
let dailyAiWords = {};
try {
    dailyAiWords = JSON.parse(localStorage.getItem("daily_ai_words")) || {};
} catch (e) {
    console.error("Failed to parse daily AI words cache", e);
}

// Global list of seen words to prevent duplicates
let seenWords = [];
try {
    seenWords = JSON.parse(localStorage.getItem("seen_words")) || [];
} catch (e) {
    console.error("Failed to parse seen words list", e);
}

let isFetchingWord = false;

// --- CORE DOM ELEMENTS ---
const languageSelect = document.getElementById("language-select");
const prevDayBtn = document.getElementById("prev-day-btn");
const nextDayBtn = document.getElementById("next-day-btn");
const currentSimDate = document.getElementById("current-sim-date");

const lockModeBtn = document.getElementById("lock-mode-btn");
const appModeBtn = document.getElementById("app-mode-btn");

const iphoneScreenDisplay = document.getElementById("iphone-screen-display");
const lockscreenOverlay = document.getElementById("lockscreen-overlay");
const appOverlay = document.getElementById("app-overlay");

const lockscreenTime = document.getElementById("lockscreen-time-text");
const lockscreenDate = document.getElementById("lockscreen-date-text");
const appStatusTime = document.getElementById("app-status-time");

// Widget view containers
const widgetSlotInline = document.getElementById("widget-slot-inline-container");
const widgetRectangularView = document.getElementById("widget-rectangular-view");
const widgetCircularView = document.getElementById("widget-circular-view");

// Card elements
const mainVocabCard = document.getElementById("main-vocab-card");
const listenSpeechBtn = document.getElementById("listen-speech-btn");
const favoriteBtn = document.getElementById("favorite-btn");

// App panels
const panelLearn = document.getElementById("panel-learn");
const panelHistory = document.getElementById("panel-history");
const panelSettings = document.getElementById("panel-settings");

// Code Modal Elements
const codeModal = document.getElementById("code-modal");
const viewCodeBtn = document.getElementById("view-code-btn");
const closeModalBtn = document.getElementById("close-modal-btn");
const closeModalFooterBtn = document.getElementById("close-modal-footer-btn");
const codeDisplayBlock = document.getElementById("code-display-block");

// --- INITIALIZATION ---
document.addEventListener("DOMContentLoaded", () => {
    updateClock();
    setInterval(updateClock, 30000); // Update clock every 30s
    
    bindEvents();
    syncData();
    loadEnvConfigs(); // Load API key and model config from .env if present
});

// --- CLOCK & DATE HANDLING ---
function updateClock() {
    const now = new Date();
    
    // Format hours and minutes
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeString = `${hours}:${minutes}`;
    
    lockscreenTime.textContent = timeString;
    appStatusTime.textContent = timeString;
    
    // Lockscreen Date based on active simulated date offset
    const simDate = getSimulatedDate();
    const options = { weekday: 'long', month: 'long', day: 'numeric' };
    lockscreenDate.textContent = simDate.toLocaleDateString('en-US', options);
}

function getSimulatedDate() {
    const d = new Date();
    d.setDate(d.getDate() + dateOffset);
    return d;
}

// --- SIMULATED DETERMINISTIC DATA ROTATION ---
function getSimulatedDateKey(date = getSimulatedDate()) {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${selectedLanguage}_${y}-${m}-${d}`;
}

function getCurrentWord() {
    const dateKey = getSimulatedDateKey();
    
    // Check if we already have an AI word for this date and language
    if (dailyAiWords[dateKey]) {
        return dailyAiWords[dateKey];
    }
    
    // Get fallback offline word
    const langWords = vocabulary[selectedLanguage] || vocabulary["English"];
    const simDate = getSimulatedDate();
    const startOfYear = new Date(simDate.getFullYear(), 0, 0);
    const diff = simDate - startOfYear;
    const oneDay = 1000 * 60 * 60 * 24;
    const dayOfYear = Math.floor(diff / oneDay);
    const index = (dayOfYear - 1) % langWords.length;
    const fallbackWord = langWords[index];
    
    // Auto-trigger background AI fetch if API Key is configured and we aren't currently fetching
    if (geminiApiKey && geminiApiKey.trim() && !isFetchingWord) {
        autoFetchAIWord(dateKey, selectedLanguage);
    }
    
    return fallbackWord;
}

// --- STATE SYNCHRONIZATION ---
function syncData() {
    const word = getCurrentWord();
    
    // Update Dashboard card labels
    document.getElementById("dashboard-lang-label").textContent = selectedLanguage.toUpperCase();
    
    // Card Front Details
    document.getElementById("card-pos").textContent = word.partOfSpeech;
    document.getElementById("card-foreign-word").textContent = word.foreignWord;
    document.getElementById("card-pronunciation").textContent = `/ ${word.pronunciation} /`;
    
    // Card Back Details
    document.getElementById("card-pos-back").textContent = word.partOfSpeech;
    document.getElementById("card-translation").textContent = word.translation;
    document.getElementById("card-meaning").textContent = word.meaning;
    
    // Examples Details
    document.getElementById("card-example-foreign").textContent = `"${word.exampleForeign}"`;
    document.getElementById("card-example-translation").textContent = `"${word.exampleTranslation}"`;
    
    // Update Bookmarked State on Front Card
    if (favorites.has(word.foreignWord)) {
        favoriteBtn.classList.add("favorited");
        favoriteBtn.innerHTML = '<i class="fa-solid fa-bookmark"></i>';
    } else {
        favoriteBtn.classList.remove("favorited");
        favoriteBtn.innerHTML = '<i class="fa-regular fa-bookmark"></i>';
    }
    
    // Update Lock Screen Rectangular Widget View
    document.getElementById("widget-rect-word").textContent = word.foreignWord;
    document.getElementById("widget-rect-pronunciation").textContent = `/ ${word.pronunciation} /`;
    document.getElementById("widget-rect-translation").textContent = word.translation;
    document.getElementById("widget-rect-flag").textContent = word.flag;
    
    // Update Lock Screen Circular Widget View
    document.getElementById("widget-circular-flag").textContent = word.flag;
    // Get first 3 characters of the foreign word capitalized
    const displayLetters = word.foreignWord.substring(0, 3).toUpperCase();
    document.getElementById("widget-circular-letters").textContent = displayLetters;
    
    // Update Lock Screen Inline Widget View
    document.querySelector(".widget-inline-content").innerHTML = `
        <span class="widget-flag">${word.flag}</span> 
        <span class="widget-inline-text">${word.foreignWord}: ${word.translation}</span>
    `;
    
    // Settings view lang label update
    document.getElementById("settings-current-lang").textContent = selectedLanguage;
    
    // Update AI Banner and Key hints
    const webAiStatus = document.getElementById("web-ai-status");
    const webAiKeyHint = document.getElementById("web-ai-key-hint");
    
    if (geminiApiKey && geminiApiKey.trim()) {
        webAiStatus.style.display = "flex";
        webAiKeyHint.style.display = "none";
        
        // If current word is an AI-generated word, change the badge to show it
        const dateKey = getSimulatedDateKey();
        if (dailyAiWords[dateKey]) {
            webAiStatus.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles text-purple"></i> <span>AI Active &bull; Auto-generated daily</span>';
        } else {
            webAiStatus.innerHTML = '<i class="fa-solid fa-spinner fa-spin text-purple"></i> <span>AI Loading &bull; Fetching from Gemini...</span>';
        }
    } else {
        webAiStatus.style.display = "none";
        webAiKeyHint.style.display = "block";
    }
    
    // Update History Tab
    renderHistory();
    updateClock();
}

function renderHistory() {
    const langWords = vocabulary[selectedLanguage] || vocabulary["English"];
    const historyContainer = document.getElementById("history-list-container");
    historyContainer.innerHTML = "";
    
    // Render past words (up to 7 days)
    for (let i = 0; i < 7; i++) {
        // Calculate offset day
        const simDate = getSimulatedDate();
        simDate.setDate(simDate.getDate() - i);
        
        const dateKey = getSimulatedDateKey(simDate);
        let word;
        let isAi = false;
        
        if (dailyAiWords[dateKey]) {
            word = dailyAiWords[dateKey];
            isAi = true;
        } else {
            const startOfYear = new Date(simDate.getFullYear(), 0, 0);
            const diff = simDate - startOfYear;
            const oneDay = 1000 * 60 * 60 * 24;
            const dayOfYear = Math.floor(diff / oneDay);
            
            const index = (dayOfYear - 1) % langWords.length;
            word = langWords[index];
        }
        
        const dateLabel = i === 0 ? "Today" : i === 1 ? "Yesterday" : simDate.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        
        const isFav = favorites.has(word.foreignWord);
        const favIconClass = isFav ? "fa-solid fa-bookmark active" : "fa-regular fa-bookmark";
        
        const itemHtml = `
            <div class="history-item" data-word="${word.foreignWord}">
                <div class="history-item-left">
                    <h4>${word.foreignWord}</h4>
                    <p>${word.translation} &bull; ${dateLabel}${isAi ? " &bull; AI" : ""}</p>
                </div>
                <div class="history-item-right">
                    <span class="part-badge">${word.partOfSpeech}</span>
                    <i class="${favIconClass}"></i>
                </div>
            </div>
        `;
        historyContainer.insertAdjacentHTML("beforeend", itemHtml);
    }
    
    // Bind click events on history items to show them in the card
    document.querySelectorAll(".history-item").forEach(item => {
        item.addEventListener("click", () => {
            const wordName = item.getAttribute("data-word");
            const wordObj = langWords.find(w => w.foreignWord === wordName);
            if (wordObj) {
                // Populate Dashboard card temporarily with this word
                document.getElementById("card-pos").textContent = wordObj.partOfSpeech;
                document.getElementById("card-foreign-word").textContent = wordObj.foreignWord;
                document.getElementById("card-pronunciation").textContent = `/ ${wordObj.pronunciation} /`;
                document.getElementById("card-pos-back").textContent = wordObj.partOfSpeech;
                document.getElementById("card-translation").textContent = wordObj.translation;
                document.getElementById("card-meaning").textContent = wordObj.meaning;
                document.getElementById("card-example-foreign").textContent = `"${wordObj.exampleForeign}"`;
                document.getElementById("card-example-translation").textContent = `"${wordObj.exampleTranslation}"`;
                
                // Show learn tab
                switchTab("learn");
                
                // Reset card flip
                mainVocabCard.classList.remove("flipped");
            }
        });
    });
}

// --- EVENT BINDING ---
function bindEvents() {
    // Language select changer
    languageSelect.addEventListener("change", (e) => {
        selectedLanguage = e.target.value;
        syncData();
    });
    
    // Day timeline simulator
    prevDayBtn.addEventListener("click", () => {
        dateOffset--;
        updateDateLabel();
        syncData();
    });
    
    nextDayBtn.addEventListener("click", () => {
        dateOffset++;
        updateDateLabel();
        syncData();
    });
    
    // Widget Style Selectors
    document.querySelectorAll(".widget-style-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelectorAll(".widget-style-btn").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            
            widgetStyle = btn.getAttribute("data-style");
            updateWidgetStyles();
        });
    });
    
    // Lock/Unlock Device transitions
    lockModeBtn.addEventListener("click", () => lockPhone());
    appModeBtn.addEventListener("click", () => unlockPhone());
    
    lockscreenOverlay.addEventListener("click", (e) => {
        // Prevent click unlock if clicking interactive buttons (flashlight/camera/widgets)
        if (e.target.closest(".quick-action-btn") || e.target.closest(".lockscreen-widgets-container")) {
            return;
        }
        unlockPhone();
    });
    
    document.getElementById("lock-phone-shortcut").addEventListener("click", () => lockPhone());
    
    // Wallpapers
    document.querySelectorAll(".wallpaper-btn").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelectorAll(".wallpaper-btn").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            
            const bgClass = btn.getAttribute("data-bg");
            
            // Clear current wallpaper class
            iphoneScreenDisplay.className = "iphone-screen " + bgClass;
        });
    });
    
    // 3D Card Flip
    mainVocabCard.addEventListener("click", (e) => {
        // Prevent flipping if clicking the speaker listen button or bookmark button
        if (e.target.closest("#listen-speech-btn") || e.target.closest("#favorite-btn")) {
            return;
        }
        mainVocabCard.classList.toggle("flipped");
    });
    
    // Pronunciation Synthesizer
    listenSpeechBtn.addEventListener("click", () => speakWordOfCard());
    
    // Favorite/Bookmark
    favoriteBtn.addEventListener("click", () => {
        const word = getCurrentWord();
        if (favorites.has(word.foreignWord)) {
            favorites.delete(word.foreignWord);
        } else {
            favorites.add(word.foreignWord);
        }
        syncData();
    });
    
    // Tab navigation
    document.querySelectorAll(".app-tabbar .tab-item").forEach(tab => {
        tab.addEventListener("click", () => {
            const targetTab = tab.getAttribute("data-tab");
            switchTab(targetTab);
        });
    });
    
    // Modal Code Viewer
    viewCodeBtn.addEventListener("click", () => openCodeModal());
    closeModalBtn.addEventListener("click", () => closeCodeModal());
    closeModalFooterBtn.addEventListener("click", () => closeCodeModal());
    
    document.querySelectorAll(".code-tab-btn").forEach(tab => {
        tab.addEventListener("click", () => {
            document.querySelectorAll(".code-tab-btn").forEach(t => t.classList.remove("active"));
            tab.classList.add("active");
            const file = tab.getAttribute("data-codefile");
            renderCodeContent(file);
        });
    });
    
    // Gemini API settings row sync
    const webApiKeyField = document.getElementById("web-api-key");
    if (webApiKeyField) {
        webApiKeyField.value = geminiApiKey;
        webApiKeyField.addEventListener("input", (e) => {
            geminiApiKey = e.target.value;
            localStorage.setItem("gemini_api_key", geminiApiKey);
            syncData();
        });
    }
    
}

async function autoFetchAIWord(dateKey, language) {
    if (!geminiApiKey.trim() || isFetchingWord) return;
    
    isFetchingWord = true;
    syncData(); // Show loader spinner in syncData
    
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${geminiModel}:generateContent?key=${geminiApiKey}`;
    
    // Add seen words array to prompt dynamically to guarantee no duplicate generation
    let excludePrompt = "";
    if (seenWords.length > 0) {
        excludePrompt = ` IMPORTANT: Do not choose any of the following previously generated words: [${seenWords.join(", ")}]. You must select a completely new and unique word.`;
    }
    
    const prompt = language === "English" 
        ? `Generate a high-yield, academic English vocabulary word commonly found in the GRE exam (Graduate Record Examinations) for graduate-level verbal reasoning preparation. Focus on advanced, precise, or challenging words. The 'translation' field should be a 1-3 word simplified synonym. The explanation, meaning, and example sentences should all be in English. Do not use translation languages like Vietnamese.${excludePrompt}`
        : `Generate a useful Japanese vocabulary word (written in Kanji or Kana, e.g. 木漏れ日). The 'translation' field should be the English meaning. The pronunciation should be romaji. The meaning and exampleTranslation should be written in English. The exampleForeign must be in Japanese.${excludePrompt}`;
        
    const payload = {
        contents: [
            { parts: [{ text: prompt }] }
        ],
        generationConfig: {
            responseMimeType: "application/json",
            responseSchema: {
                type: "OBJECT",
                properties: {
                    foreignWord: { type: "STRING" },
                    translation: { type: "STRING" },
                    pronunciation: { type: "STRING" },
                    partOfSpeech: { type: "STRING" },
                    meaning: { type: "STRING" },
                    exampleForeign: { type: "STRING" },
                    exampleTranslation: { type: "STRING" },
                    language: { type: "STRING" }
                },
                required: ["foreignWord", "translation", "pronunciation", "partOfSpeech", "meaning", "exampleForeign", "exampleTranslation", "language"]
            }
        }
    };
    
    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
            const errData = await response.json();
            throw new Error(errData.error?.message || "Received invalid response from Gemini servers.");
        }
        
        const data = await response.json();
        const rawText = data.candidates[0].content.parts[0].text;
        const word = JSON.parse(rawText.trim());
        
        // Populate standard simulated items
        word.id = Math.random().toString(36).substring(7);
        word.language = language;
        word.flag = language === "English" ? "🇬🇧" : "🇯🇵";
        word.bcp47 = language === "English" ? "en-GB" : "ja-JP";
        
        // Save to cache
        dailyAiWords[dateKey] = word;
        localStorage.setItem("daily_ai_words", JSON.stringify(dailyAiWords));
        
        // Record in duplicate prevention list
        const lowerWord = word.foreignWord.toLowerCase().trim();
        if (!seenWords.includes(lowerWord)) {
            seenWords.push(lowerWord);
            localStorage.setItem("seen_words", JSON.stringify(seenWords));
        }
        
        // Reset card flip
        mainVocabCard.classList.remove("flipped");
        
    } catch (e) {
        console.error("Auto AI Generation Error:", e.message);
    } finally {
        isFetchingWord = false;
        syncData();
    }
}

async function loadEnvConfigs() {
    try {
        const response = await fetch('/.env');
        if (response.ok) {
            const text = await response.text();
            
            // Extract GEMINI_API_KEY
            const keyMatch = text.match(/GEMINI_API_KEY\s*=\s*["']?([^"'\r\n#]+)["']?/);
            if (keyMatch && keyMatch[1]) {
                const loadedKey = keyMatch[1].trim();
                if (loadedKey && loadedKey !== "YOUR_API_KEY_HERE") {
                    geminiApiKey = loadedKey;
                    localStorage.setItem("gemini_api_key", geminiApiKey);
                    
                    const webApiKeyField = document.getElementById("web-api-key");
                    if (webApiKeyField) {
                        webApiKeyField.value = geminiApiKey;
                    }
                }
            }
            
            // Extract GEMINI_MODEL
            const modelMatch = text.match(/GEMINI_MODEL\s*=\s*["']?([^"'\r\n#]+)["']?/);
            if (modelMatch && modelMatch[1]) {
                geminiModel = modelMatch[1].trim();
                localStorage.setItem("gemini_model", geminiModel);
            }
            
            syncData();
        }
    } catch (e) {
        console.warn("No local .env file found or accessible. Using manual settings.", e);
    }
}

function updateDateLabel() {
    if (dateOffset === 0) {
        currentSimDate.textContent = "Today";
    } else if (dateOffset === 1) {
        currentSimDate.textContent = "Tomorrow";
    } else if (dateOffset === -1) {
        currentSimDate.textContent = "Yesterday";
    } else if (dateOffset > 1) {
        currentSimDate.textContent = `+${dateOffset} Days`;
    } else {
        currentSimDate.textContent = `${dateOffset} Days`;
    }
}

function updateWidgetStyles() {
    // Hide all
    widgetSlotInline.style.display = "none";
    widgetRectangularView.style.display = "none";
    widgetCircularView.style.display = "none";
    
    if (widgetStyle === "inline") {
        widgetSlotInline.style.display = "inline-flex";
    } else if (widgetStyle === "rectangular") {
        widgetRectangularView.style.display = "flex";
    } else if (widgetStyle === "circular") {
        widgetCircularView.style.display = "flex";
    }
}

function unlockPhone() {
    isPhoneLocked = false;
    lockscreenOverlay.style.display = "none";
    appOverlay.style.display = "flex";
    
    lockModeBtn.classList.remove("active");
    appModeBtn.classList.add("active");
}

function lockPhone() {
    isPhoneLocked = true;
    appOverlay.style.display = "none";
    lockscreenOverlay.style.display = "flex";
    
    appModeBtn.classList.remove("active");
    lockModeBtn.classList.add("active");
    
    // Reset flip state when locking
    mainVocabCard.classList.remove("flipped");
}

function switchTab(tabName) {
    activeTab = tabName;
    
    // Update tab bar buttons
    document.querySelectorAll(".app-tabbar .tab-item").forEach(btn => {
        if (btn.getAttribute("data-tab") === tabName) {
            btn.classList.add("active");
        } else {
            btn.classList.remove("active");
        }
    });
    
    // Hide all panels
    panelLearn.style.display = "none";
    panelHistory.style.display = "none";
    panelSettings.style.display = "none";
    
    // Show selected panel
    if (tabName === "learn") {
        panelLearn.style.display = "flex";
    } else if (tabName === "history") {
        panelHistory.style.display = "flex";
    } else if (tabName === "settings") {
        panelSettings.style.display = "flex";
    }
}

// --- TEXT TO SPEECH (BCP-47 Voice Accents) ---
function speakWordOfCard() {
    const word = getCurrentWord();
    
    if ('speechSynthesis' in window) {
        // Stop current speech first
        window.speechSynthesis.cancel();
        
        const utterance = new SpeechSynthesisUtterance(word.foreignWord);
        utterance.lang = word.bcp47;
        utterance.rate = 0.85; // slightly slower for language learners
        
        // Find matching voice if possible (browser support varies)
        const voices = window.speechSynthesis.getVoices();
        const matchingVoice = voices.find(voice => voice.lang.includes(word.bcp47));
        if (matchingVoice) {
            utterance.voice = matchingVoice;
        }
        
        window.speechSynthesis.speak(utterance);
    } else {
        alert("Text-to-speech is not supported in this browser. Please try Chrome, Safari, or Edge.");
    }
}

// --- CODE VIEWER MODAL CONTROLS ---
function openCodeModal() {
    codeModal.style.display = "flex";
    
    // Load first tab
    const activeTabBtn = document.querySelector(".code-tab-btn.active");
    const activeFile = activeTabBtn.getAttribute("data-codefile");
    renderCodeContent(activeFile);
}

function closeCodeModal() {
    codeModal.style.display = "none";
}

function renderCodeContent(fileKey) {
    const rawCode = swiftCodes[fileKey] || "";
    // Clean and escape any HTML tags if necessary, but here we just assign directly to code block
    // since it's inside a <pre><code> block
    codeDisplayBlock.textContent = rawCode;
}
