// --- VOCABULARY DATA (Matches Swift VocabularyData.words) ---
const vocabulary = {
    Spanish: [
        { foreignWord: "palabra", translation: "word", pronunciation: "pah-LAH-brah", partOfSpeech: "noun", meaning: "A single distinct meaningful element of speech or writing.", exampleForeign: "Esta palabra en español es muy hermosa.", exampleTranslation: "This word in Spanish is very beautiful.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "crecer", translation: "to grow", pronunciation: "kreh-SEHR", partOfSpeech: "verb", meaning: "To undergo natural development by increasing in size and changing physically.", exampleForeign: "Las flores crecen rápidamente en primavera.", exampleTranslation: "Flowers grow quickly in spring.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "amanecer", translation: "dawn", pronunciation: "ah-mah-neh-SEHR", partOfSpeech: "noun", meaning: "The first appearance of light in the sky before sunrise.", exampleForeign: "Me gusta ver el amanecer frente al mar.", exampleTranslation: "I like to watch the dawn in front of the sea.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "desafío", translation: "challenge", pronunciation: "deh-sah-FEE-oh", partOfSpeech: "noun", meaning: "A task or situation that tests someone's abilities.", exampleForeign: "Aprender un nuevo idioma es un gran desafío.", exampleTranslation: "Learning a new language is a great challenge.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "sonreír", translation: "to smile", pronunciation: "sohn-ray-EER", partOfSpeech: "verb", meaning: "Form one's features into a pleased or kind expression.", exampleForeign: "Ella siempre sonríe cuando está feliz.", exampleTranslation: "She always smiles when she is happy.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "mariposa", translation: "butterfly", pronunciation: "mah-ree-POH-sah", partOfSpeech: "noun", meaning: "An insect with broad, often brightly colored wings.", exampleForeign: "La mariposa vuela sobre las flores del jardín.", exampleTranslation: "The butterfly flies over the flowers in the garden.", bcp47: "es-ES", flag: "🇪🇸" },
        { foreignWord: "descubrir", translation: "to discover", pronunciation: "dehs-koo-BREER", partOfSpeech: "verb", meaning: "Find unexpectedly or during a search.", exampleForeign: "Queremos descubrir nuevos lugares este fin de semana.", exampleTranslation: "We want to discover new places this weekend.", bcp47: "es-ES", flag: "🇪🇸" }
    ],
    French: [
        { foreignWord: "espoir", translation: "hope", pronunciation: "ess-pwahr", partOfSpeech: "noun", meaning: "A feeling of expectation and desire for a certain thing to happen.", exampleForeign: "Il y a toujours de l'espoir, même dans les moments difficiles.", exampleTranslation: "There is always hope, even in difficult times.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "découvrir", translation: "to discover", pronunciation: "day-koo-vreer", partOfSpeech: "verb", meaning: "To find unexpectedly or acquire knowledge of for the first time.", exampleForeign: "J'adore découvrir de nouvelles cultures.", exampleTranslation: "I love to discover new cultures.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "flâner", translation: "to wander / stroll", pronunciation: "flah-nay", partOfSpeech: "verb", meaning: "To lounge or saunter around idly.", exampleForeign: "Nous flânons souvent dans les rues de Paris le dimanche.", exampleTranslation: "We often stroll in the streets of Paris on Sundays.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "étoile", translation: "star", pronunciation: "ay-twahl", partOfSpeech: "noun", meaning: "A luminous point in the night sky which is a large, remote incandescent body.", exampleForeign: "Regarde le ciel, il y a beaucoup d'étoiles ce soir.", exampleTranslation: "Look at the sky, there are many stars tonight.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "bienveillance", translation: "benevolence / kindness", pronunciation: "byeh-vay-lahns", partOfSpeech: "noun", meaning: "The quality of well-meaning; kindness.", exampleForeign: "Sa bienveillance envers les autres est admirable.", exampleTranslation: "Her kindness towards others is admirable.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "éphémère", translation: "ephemeral", pronunciation: "ay-fay-mair", partOfSpeech: "adjective", meaning: "Lasting for a very short time.", exampleForeign: "La beauté des fleurs de cerisier est éphémère.", exampleTranslation: "The beauty of cherry blossoms is ephemeral.", bcp47: "fr-FR", flag: "🇫🇷" },
        { foreignWord: "voyager", translation: "to travel", pronunciation: "vwah-yah-jay", partOfSpeech: "verb", meaning: "Go on a journey, typically of some length or abroad.", exampleForeign: "Voyager permet d'ouvrir son esprit.", exampleTranslation: "Traveling allows one to open their mind.", bcp47: "fr-FR", flag: "🇫🇷" }
    ],
    Japanese: [
        { foreignWord: "Komorebi (木漏れ日)", translation: "sunlight filtering through trees", pronunciation: "ko-mo-reh-bee", partOfSpeech: "noun", meaning: "The sunlight that filters through the leaves of trees.", exampleForeign: "森を歩くと、美しい木漏れ日が見られます。", exampleTranslation: "Walking through the forest, you can see beautiful sunlight filtering through trees.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Kintsugi (金継ぎ)", translation: "golden pottery repair", pronunciation: "keen-tsoo-gee", partOfSpeech: "noun", meaning: "The Japanese art of repairing broken pottery with lacquer dusted or mixed with powdered gold.", exampleForeign: "金継ぎは、壊れたものに新しい命を吹き込みます。", exampleTranslation: "Kintsugi breathes new life into broken objects.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Ikigai (生き甲斐)", translation: "a reason for being", pronunciation: "ee-kee-guy", partOfSpeech: "noun", meaning: "A concept referring to something that gives a person a sense of purpose or a reason for living.", exampleForeign: "私の生き甲斐は、人々の役に立つことです。", exampleTranslation: "My reason for being is to be useful to people.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Kaizen (改善)", translation: "continuous improvement", pronunciation: "kye-zen", partOfSpeech: "noun", meaning: "A Japanese business philosophy of continuous improvement of working practices and personal efficiency.", exampleForeign: "毎日少しずつ業務を改善していきます。", exampleTranslation: "We will improve our business operations little by little every day.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Natsukashii (懐かしい)", translation: "nostalgic / dear", pronunciation: "nah-tsoo-kah-shee", partOfSpeech: "adjective", meaning: "Bringing back fond memories of the past; nostalgic.", exampleForeign: "この古いアルバムを見ると、子供の頃が懐かしいです。", exampleTranslation: "Looking at this old album makes me feel nostalgic for my childhood.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Wabi-Sabi (侘寂)", translation: "imperfect beauty", pronunciation: "wah-bee-sah-bee", partOfSpeech: "noun", meaning: "A world view centered on the acceptance of transience and imperfection.", exampleForeign: "日本の古い茶碗には、侘寂の心があります。", exampleTranslation: "There is a spirit of wabi-sabi in ancient Japanese teacups.", bcp47: "ja-JP", flag: "🇯🇵" },
        { foreignWord: "Yūgen (幽玄)", translation: "profound grace / mystery", pronunciation: "yoo-gen", partOfSpeech: "noun", meaning: "An important concept in traditional Japanese aesthetics, meaning a profound, mysterious sense of beauty.", exampleForeign: "この日本庭園には幽玄の美があります。", exampleTranslation: "This Japanese garden has a profound, mysterious beauty.", bcp47: "ja-JP", flag: "🇯🇵" }
    ],
    German: [
        { foreignWord: "Fernweh", translation: "longing to travel", pronunciation: "FEHRN-vay", partOfSpeech: "noun", meaning: "A longing for distant places; the opposite of homesickness (Heimweh).", exampleForeign: "Im Winter packt mich immer das Fernweh.", exampleTranslation: "In winter I am always seized by the longing to travel.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Sehnsucht", translation: "nostalgic yearning", pronunciation: "ZAYN-zookht", partOfSpeech: "noun", meaning: "A deep longing or yearning for something distant or intangible.", exampleForeign: "Er hat eine große Sehnsucht nach der Heimat.", exampleTranslation: "He has a great yearning for his homeland.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Zeitgeist", translation: "spirit of the time", pronunciation: "TSYTE-gyste", partOfSpeech: "noun", meaning: "The defining spirit or mood of a particular period of history as shown by the ideas and beliefs of the time.", exampleForeign: "Dieser Film fängt den Zeitgeist der Neunziger perfekt ein.", exampleTranslation: "This movie perfectly captures the spirit of the nineties.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Schadenfreude", translation: "harm-joy", pronunciation: "SHAH-den-froy-deh", partOfSpeech: "noun", meaning: "Pleasure derived by someone from another person's misfortune.", exampleForeign: "Es liegt eine gewisse Schadenfreude in seinem Lächeln.", exampleTranslation: "There is a certain Schadenfreude in his smile.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Gemütlichkeit", translation: "coziness / comfort", pronunciation: "geh-MOOT-likh-kyte", partOfSpeech: "noun", meaning: "A state of warmth, friendliness, and good cheer, inducing a cozy atmosphere.", exampleForeign: "Das kleine Café strahlte eine wunderbare Gemütlichkeit aus.", exampleTranslation: "Das kleine Café strahlte eine wunderbare Gemütlichkeit aus.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Kummerspeck", translation: "grief-bacon", pronunciation: "KOOM-mer-shpek", partOfSpeech: "noun", meaning: "The excess weight gained from emotional overeating during periods of stress or grief.", exampleForeign: "Nach der Trennung hatte sie ein bisschen Kummerspeck.", exampleTranslation: "After the breakup, she had a bit of grief-bacon.", bcp47: "de-DE", flag: "🇩🇪" },
        { foreignWord: "Weltschmerz", translation: "world-weariness", pronunciation: "VELT-shmerts", partOfSpeech: "noun", meaning: "A feeling of melancholy and world-weariness, caused by a comparison of the actual state of the world with an ideal state.", exampleForeign: "Manchmal überkommt mich ein tiefer Weltschmerz.", exampleTranslation: "Sometimes a deep world-weariness overcomes me.", bcp47: "de-DE", flag: "🇩🇪" }
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
    public static let languages = ["Spanish", "French", "Japanese", "German"]
    
    public static let words: [String: [Word]] = [
        "Spanish": [
            Word(foreignWord: "palabra", translation: "word", pronunciation: "pah-LAH-brah", partOfSpeech: "noun", ...),
            Word(foreignWord: "crecer", translation: "to grow", pronunciation: "kreh-SEHR", partOfSpeech: "verb", ...),
            // See Shared/VocabularyData.swift for complete dictionary entries
        ],
        "French": [ ... ],
        "Japanese": [ ... ],
        "German": [ ... ]
    ]
    
    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "Spanish"
        let languageWords = words[selectedLanguage] ?? words["Spanish"]!
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % languageWords.count
        
        return languageWords[index]
    }
    
    public static func getHistory(for language: String, limit: Int = 10, relativeTo date: Date = Date()) -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "Spanish"
        let languageWords = words[selectedLanguage] ?? words["Spanish"]!
        
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
        self.selectedLanguage = sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "Spanish"
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
let selectedLanguage = "Spanish";
let dateOffset = 0; // Days offset from today
let favorites = new Set();
let isPhoneLocked = true;
let activeTab = "learn";
let widgetStyle = "rectangular";

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
function getCurrentWord() {
    const langWords = vocabulary[selectedLanguage] || vocabulary["Spanish"];
    const simDate = getSimulatedDate();
    
    // Hashing algorithm matches Swift: day of year % words count
    const startOfYear = new Date(simDate.getFullYear(), 0, 0);
    const diff = simDate - startOfYear;
    const oneDay = 1000 * 60 * 60 * 24;
    const dayOfYear = Math.floor(diff / oneDay);
    
    const index = (dayOfYear - 1) % langWords.length;
    return langWords[index];
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
    
    // Update History Tab
    renderHistory();
    updateClock();
}

function renderHistory() {
    const langWords = vocabulary[selectedLanguage] || vocabulary["Spanish"];
    const historyContainer = document.getElementById("history-list-container");
    historyContainer.innerHTML = "";
    
    // Render past words (up to 7 days)
    for (let i = 0; i < 7; i++) {
        // Calculate offset day
        const simDate = getSimulatedDate();
        simDate.setDate(simDate.getDate() - i);
        
        const startOfYear = new Date(simDate.getFullYear(), 0, 0);
        const diff = simDate - startOfYear;
        const oneDay = 1000 * 60 * 60 * 24;
        const dayOfYear = Math.floor(diff / oneDay);
        
        const index = (dayOfYear - 1) % langWords.length;
        const word = langWords[index];
        
        const dateLabel = i === 0 ? "Today" : i === 1 ? "Yesterday" : simDate.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
        
        const isFav = favorites.has(word.foreignWord);
        const favIconClass = isFav ? "fa-solid fa-bookmark active" : "fa-regular fa-bookmark";
        
        const itemHtml = `
            <div class="history-item" data-word="${word.foreignWord}">
                <div class="history-item-left">
                    <h4>${word.foreignWord}</h4>
                    <p>${word.translation} &bull; ${dateLabel}</p>
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
