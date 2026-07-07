// --- VOCABULARY DATA (Matches Swift VocabularyData.words) ---
const vocabulary = {
    English: [],
    Japanese: []
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

// Gemini configuration removed

// Daily Firebase words cache, dictionary of date string to Word: [Language_YYYY-MM-DD : Word]
let dailyAiWords = {}; // Start with a fresh cache on startup to force Firebase sync

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
    const langWords = vocabulary[selectedLanguage] || [];
    
    // Auto-trigger background Firestore fetch if we aren't currently fetching
    if (!isFetchingWord && !window.failedFetches?.[dateKey]) {
        autoFetchAIWord(dateKey, selectedLanguage);
    }
    
    if (langWords.length === 0) {
        return {
            foreignWord: selectedLanguage === "English" ? "LingoLock English" : "LingoLock 日本語",
            pronunciation: "...",
            romanization: "",
            partOfSpeech: "noun",
            meaning: `Syncing your daily vocabulary from Firebase Firestore...`,
            nativeMeaning: `Syncing your daily vocabulary from Firebase Firestore...`,
            englishMeaning: "",
            exampleForeign: "Syncing...",
            exampleTranslation: "",
            language: selectedLanguage,
            level: "beginner",
            tags: [],
            bcp47: selectedLanguage === "English" ? "en-GB" : "ja-JP"
        };
    }
    
    const simDate = getSimulatedDate();
    const startOfYear = new Date(simDate.getFullYear(), 0, 0);
    const diff = simDate - startOfYear;
    const oneDay = 1000 * 60 * 60 * 24;
    const dayOfYear = Math.floor(diff / oneDay);
    const index = (dayOfYear - 1) % langWords.length;
    return langWords[index];
}

function getDisplayTranslation(word) {
    if (word.language === "Japanese") {
        const englishMeaning = getDisplayEnglishMeaning(word);
        if (englishMeaning) return englishMeaning;
    }

    const nativeMeaning = (word.nativeMeaning || "").trim();
    if (nativeMeaning) return nativeMeaning;

    const legacyMeaning = (word.meaning || "").trim();
    if (word.language === "Japanese" && legacyMeaning) return legacyMeaning;

    const legacyTranslation = (word.translation || "").trim();
    if (legacyTranslation) return legacyTranslation;

    return legacyMeaning;
}

function getDisplayMeaning(word) {
    if (word.language === "Japanese") {
        const englishMeaning = getDisplayEnglishMeaning(word);
        if (englishMeaning) return englishMeaning;
    }

    return (word.nativeMeaning || word.meaning || word.translation || "").trim();
}

function getDisplayEnglishMeaning(word) {
    const englishMeaning = (word.englishMeaning || "").trim();
    if (englishMeaning) return englishMeaning;
    return word.language === "Japanese" ? (word.translation || "").trim() : "";
}

function getDisplayPronunciation(word) {
    const pronunciation = (word.pronunciation || "").trim();
    if (!pronunciation) return "";

    if (word.language === "Japanese") {
        return containsJapaneseScript(pronunciation) ? pronunciation : "";
    }

    return formatPronunciation(pronunciation);
}

function containsJapaneseScript(text) {
    return /[\u3040-\u30ff\u3400-\u9fff]/.test(text);
}

// --- STATE SYNCHRONIZATION ---
function syncData() {
    const word = getCurrentWord();
    const formattedPron = getDisplayPronunciation(word);
    
    // Update Dashboard card labels
    document.getElementById("dashboard-lang-label").textContent = selectedLanguage.toUpperCase();
    
    // Card Front Details
    document.getElementById("card-pos").textContent = word.partOfSpeech;
    document.getElementById("card-foreign-word").textContent = word.foreignWord;
    const translationFront = document.getElementById("card-translation-front");
    if (translationFront) {
        const englishMeaning = getDisplayEnglishMeaning(word);
        translationFront.textContent = getDisplayTranslation(word) + (englishMeaning ? ` · EN: ${englishMeaning}` : "");
    }
    const cardPron = document.getElementById("card-pronunciation");
    cardPron.textContent = formattedPron;
    cardPron.style.display = formattedPron ? "block" : "none";
    
    // Card Back Details
    document.getElementById("card-pos-back").textContent = word.partOfSpeech;
    document.getElementById("card-meaning").textContent = getDisplayMeaning(word);
    
    // Examples Details
    document.getElementById("card-example-foreign").textContent = `"${word.exampleForeign}"`;
    
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
    const widgetRectPron = document.getElementById("widget-rect-pronunciation");
    widgetRectPron.textContent = formattedPron;
    widgetRectPron.style.display = formattedPron ? "block" : "none";
    const displayTranslation = getDisplayTranslation(word);
    document.getElementById("widget-rect-translation").textContent = displayTranslation || word.partOfSpeech.toUpperCase();
    // Update Lock Screen Circular Widget View
    const displayLetters = word.foreignWord.substring(0, 3).toUpperCase();
    document.getElementById("widget-circular-letters").textContent = displayLetters;
    
    // Update Lock Screen Inline Widget View
    const inlineText = word.foreignWord + (displayTranslation ? ` - ${displayTranslation}` : (formattedPron ? ` ${formattedPron}` : ""));
    document.querySelector(".widget-inline-content").innerHTML = `
        <span class="widget-inline-text">${inlineText}</span>
    `;
    
    // Settings view lang label update
    document.getElementById("settings-current-lang").textContent = selectedLanguage;
    
    // Update Firebase Status and Sync button
    const webAiStatus = document.getElementById("web-ai-status");
    const webAiKeyHint = document.getElementById("web-ai-key-hint");
    const webAiGenerateBtn = document.getElementById("web-ai-generate-btn");
    
    webAiStatus.style.display = "flex";
    webAiKeyHint.style.display = "block";
    if (webAiGenerateBtn) webAiGenerateBtn.style.display = "flex";
    
    const dateKey = getSimulatedDateKey();
    if (dailyAiWords[dateKey]) {
        webAiStatus.innerHTML = '<i class="fa-solid fa-cloud text-blue"></i> <span>Firebase Connected</span>';
    } else {
        webAiStatus.innerHTML = '<i class="fa-solid fa-spinner fa-spin text-blue"></i> <span>Syncing...</span>';
    }
    
    // Update History Tab
    renderHistory();
    updateClock();
}

function renderHistory() {
    const langWords = vocabulary[selectedLanguage] || [];
    const historyContainer = document.getElementById("history-list-container");
    historyContainer.innerHTML = "";
    
    let renderedCount = 0;
    
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
        } else if (langWords.length > 0) {
            const startOfYear = new Date(simDate.getFullYear(), 0, 0);
            const diff = simDate - startOfYear;
            const oneDay = 1000 * 60 * 60 * 24;
            const dayOfYear = Math.floor(diff / oneDay);
            
            const index = (dayOfYear - 1) % langWords.length;
            word = langWords[index];
        }
        
        if (!word) {
            continue; // Skip rendering empty days
        }
        
        renderedCount++;
        const dateLabel = i === 0 ? "Today" : i === 1 ? "Yesterday" : simDate.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        
        const isFav = favorites.has(word.foreignWord);
        const favIconClass = isFav ? "fa-solid fa-bookmark active" : "fa-regular fa-bookmark";
        
        const itemHtml = `
            <div class="history-item" data-word="${word.foreignWord}">
                <div class="history-item-left">
                    <h4>${word.foreignWord}</h4>
                    <p>${getDisplayTranslation(word)} &bull; ${dateLabel}${isAi ? " &bull; AI" : ""}</p>
                </div>
                <div class="history-item-right">
                    <span class="part-badge">${word.partOfSpeech}</span>
                    <i class="${favIconClass}"></i>
                </div>
            </div>
        `;
        historyContainer.insertAdjacentHTML("beforeend", itemHtml);
    }
    
    if (renderedCount === 0) {
        historyContainer.innerHTML = `<p class="no-history-text" style="color: var(--text-secondary); text-align: center; padding: 2rem 1rem;">No history items available. Set up your Gemini API key in Settings to begin.</p>`;
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
                const translationFront = document.getElementById("card-translation-front");
                if (translationFront) {
                    const englishMeaning = getDisplayEnglishMeaning(wordObj);
                    translationFront.textContent = getDisplayTranslation(wordObj) + (englishMeaning ? ` · EN: ${englishMeaning}` : "");
                }
                const formattedObjPron = getDisplayPronunciation(wordObj);
                const cardPron = document.getElementById("card-pronunciation");
                cardPron.textContent = formattedObjPron;
                cardPron.style.display = formattedObjPron ? "block" : "none";
                document.getElementById("card-pos-back").textContent = wordObj.partOfSpeech;
                document.getElementById("card-meaning").textContent = getDisplayMeaning(wordObj);
                document.getElementById("card-example-foreign").textContent = `"${wordObj.exampleForeign}"`;
                
                // Show learn tab
                switchTab("learn");
                
                // Reset card flip
                mainVocabCard.classList.remove("flipped");
                updateExamplePanelVisibility();
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
        updateExamplePanelVisibility();
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
    
    // Sync button event listener
    const webAiGenerateBtn = document.getElementById("web-ai-generate-btn");
    if (webAiGenerateBtn) {
        webAiGenerateBtn.addEventListener("click", () => {
            const dateKey = getSimulatedDateKey();
            const language = document.getElementById("language-select").value;
            autoFetchAIWord(dateKey, language, true);
        });
    }
}

window.failedFetches = window.failedFetches || {};

async function autoFetchAIWord(dateKey, language, force = false) {
    if (isFetchingWord) return;
    
    isFetchingWord = true;
    if (force) {
        window.failedFetches[dateKey] = false;
    }
    syncData(); // Show loader spinner in syncData
    
    try {
        const projectId = "web1-d1df7";
        const url = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/words`;
        
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error("Failed to fetch words from Firestore database.");
        }
        
        const data = await response.json();
        const documents = data.documents;
        if (!documents || documents.length === 0) {
            throw new Error("No words found in Firestore. Make sure you populated the database.");
        }
        
        // Filter by language
        const langWords = documents.filter(doc => {
            const fields = doc.fields;
            return fields && fields.language && fields.language.stringValue === language;
        });
        
        if (langWords.length === 0) {
            throw new Error(`No words found for language: ${language}`);
        }
        
        // Pick index
        let index;
        if (force) {
            index = Math.floor(Math.random() * langWords.length);
        } else {
            const simDate = getSimulatedDate();
            const start = new Date(simDate.getFullYear(), 0, 0);
            const diff = simDate - start;
            const oneDay = 1000 * 60 * 60 * 24;
            const dayOfYear = Math.floor(diff / oneDay);
            index = (dayOfYear - 1) % langWords.length;
        }
        
        const doc = langWords[index];
        const fields = doc.fields;
        const tags = fields.tags?.arrayValue?.values
            ?.map(value => value.stringValue)
            .filter(Boolean) || [];
        
        const word = {
            id: doc.name.split("/").pop(),
            foreignWord: fields.foreignWord?.stringValue || "",
            translation: fields.translation?.stringValue || "",
            pronunciation: fields.pronunciation?.stringValue || "",
            romanization: fields.romanization?.stringValue || "",
            partOfSpeech: fields.partOfSpeech?.stringValue || "noun",
            meaning: fields.meaning?.stringValue || "",
            nativeMeaning: fields.nativeMeaning?.stringValue || "",
            englishMeaning: fields.englishMeaning?.stringValue || "",
            exampleForeign: fields.exampleForeign?.stringValue || "",
            exampleTranslation: fields.exampleTranslation?.stringValue || "",
            language: language,
            level: fields.level?.stringValue || "beginner",
            tags,
            bcp47: language === "English" ? "en-GB" : "ja-JP"
        };
        
        // Save to cache
        dailyAiWords[dateKey] = word;
        localStorage.setItem("daily_ai_words", JSON.stringify(dailyAiWords));
        
        // Reset card flip
        mainVocabCard.classList.remove("flipped");
        updateExamplePanelVisibility();
        window.failedFetches[dateKey] = false;
        
    } catch (e) {
        console.error("Firestore fetch error:", e.message);
        window.failedFetches[dateKey] = true;
        alert(`Firebase fetch error: ${e.message}`);
    } finally {
        isFetchingWord = false;
        syncData();
    }
}

// loadEnvConfigs removed

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
    updateExamplePanelVisibility();
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

function speakWordOfCard() {
    const word = getCurrentWord();
    
    if ('speechSynthesis' in window) {
        // Stop current speech first
        window.speechSynthesis.cancel();
        
        // Clean up parentheticals for cleaner speech
        let textToSpeak = word.foreignWord;
        const parenIndex = textToSpeak.indexOf('(');
        if (parenIndex !== -1) {
            textToSpeak = textToSpeak.substring(0, parenIndex).trim();
        }
        
        const utterance = new SpeechSynthesisUtterance(textToSpeak);
        utterance.lang = word.bcp47;
        utterance.rate = 0.85; // slightly slower for language learners
        
        // Find matching voice if possible (browser support varies)
        const voices = window.speechSynthesis.getVoices();
        const langCode = word.bcp47.toLowerCase().replace('_', '-');
        const langPrefix = langCode.split('-')[0];
        
        let matchingVoice = voices.find(voice => {
            const voiceLang = voice.lang.toLowerCase().replace('_', '-');
            return voiceLang === langCode;
        });
        
        if (!matchingVoice) {
            matchingVoice = voices.find(voice => {
                const voiceLang = voice.lang.toLowerCase().replace('_', '-');
                return voiceLang.startsWith(langPrefix);
            });
        }
        
        if (matchingVoice) {
            utterance.voice = matchingVoice;
        }
        
        utterance.onerror = (event) => {
            console.error("SpeechSynthesisUtterance error:", event);
        };
        
        window.speechSynthesis.resume();
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

function updateExamplePanelVisibility() {
    const examplePanel = document.querySelector(".example-panel");
    const mainVocabCard = document.getElementById("main-vocab-card");
    if (examplePanel && mainVocabCard) {
        if (mainVocabCard.classList.contains("flipped")) {
            examplePanel.style.display = "flex";
        } else {
            examplePanel.style.display = "none";
        }
    }
}

function formatPronunciation(pron) {
    if (!pron || pron.trim() === "") {
        return "";
    }
    let p = pron.trim();
    if (p.startsWith("/")) p = p.substring(1);
    if (p.endsWith("/")) p = p.substring(0, p.length - 1);
    return `/ ${p.trim()} /`;
}
