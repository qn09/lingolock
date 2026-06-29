import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        let sampleWord = Word(foreignWord: "palabra", translation: "word", pronunciation: "pah-LAH-brah", partOfSpeech: "noun",
                              meaning: "A single distinct element of speech.",
                              exampleForeign: "Esta palabra es muy hermosa.", exampleTranslation: "This word is very beautiful.", language: "Spanish")
        return SimpleEntry(date: Date(), word: sampleWord)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let language = getSelectedLanguage()
        let word = VocabularyData.getWordOfTheDay(for: language)
        let entry = SimpleEntry(date: Date(), word: word)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let language = getSelectedLanguage()
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Generate entries for today, tomorrow, and the day after tomorrow
        // This ensures the lock screen widget continues rotating to new words daily
        // even if the user does not open the main app for several days.
        for dayOffset in 0..<3 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else { continue }
            
            // Set the update time to exactly midnight for each day
            let midnightDate = calendar.startOfDay(for: entryDate)
            let wordForDay = VocabularyData.getWordOfTheDay(for: language, date: midnightDate)
            
            // For today, make the entry trigger immediately, otherwise at midnight
            let triggerDate = dayOffset == 0 ? currentDate : midnightDate
            let entry = SimpleEntry(date: triggerDate, word: wordForDay)
            entries.append(entry)
        }

        // Reload timeline when the scheduled entries expire (e.g. after day 3)
        let expiryDate = calendar.date(byAdding: .day, value: 3, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(expiryDate))
        completion(timeline)
    }
    
    private func getSelectedLanguage() -> String {
        let appGroupId = "group.com.language.wordoftheday"
        let defaults = UserDefaults(suiteName: appGroupId)
        return defaults?.string(forKey: "selected_language") ?? "Spanish"
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let word: Word
}

struct WordOfTheDayWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        // --- LOCK SCREEN WIDGET FAMILIES (iOS 16+) ---
        case .accessoryInline:
            InlineWidgetView(word: entry.word)
            
        case .accessoryRectangular:
            RectangularWidgetView(word: entry.word)
            
        case .accessoryCircular:
            CircularWidgetView(word: entry.word)
            
        // --- HOME SCREEN WIDGET FAMILIES ---
        case .systemSmall:
            SmallWidgetView(word: entry.word)
            
        case .systemMedium:
            MediumWidgetView(word: entry.word)
            
        default:
            SmallWidgetView(word: entry.word)
        }
    }
}

// MARK: - Lock Screen Widgets

struct InlineWidgetView: View {
    let word: Word
    
    var body: some View {
        HStack(spacing: 4) {
            Text(languageFlag(word.language))
            Text("\(word.foreignWord): \(word.translation)")
                .fontWeight(.semibold)
        }
    }
}

struct RectangularWidgetView: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline) {
                Text(word.foreignWord)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(languageFlag(word.language))
                    .font(.caption)
            }
            
            Text("/ \(word.pronunciation) /")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .italic()
            
            Spacer(minLength: 0)
            
            Text(word.translation)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CircularWidgetView: View {
    let word: Word
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Text(languageFlag(word.language))
                    .font(.title3)
                Text(String(word.foreignWord.prefix(3)).capitalized)
                    .font(.system(size: 10, weight: .bold))
            }
        }
    }
}

// MARK: - Home Screen Widgets

struct SmallWidgetView: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(languageFlag(word.language))
                    .font(.title2)
                Spacer()
                Text(word.partOfSpeech.lowercased())
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(word.foreignWord)
                    .font(.title3)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                
                Text(word.translation)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("Word of the Day")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct MediumWidgetView: View {
    let word: Word
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(languageFlag(word.language))
                        .font(.title3)
                    Text("Word of the Day")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                }
                
                Spacer(minLength: 0)
                
                Text(word.foreignWord)
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Text("/ \(word.pronunciation) /")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                
                Text(word.translation)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("EXAMPLE SENTENCE")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                Text(word.exampleForeign)
                    .font(.subheadline)
                    .italic()
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                
                Text(word.exampleTranslation)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Helper Methods

func languageFlag(_ language: String) -> String {
    switch language {
    case "Spanish": return "🇪🇸"
    case "French": return "🇫🇷"
    case "Japanese": return "🇯🇵"
    case "German": return "🇩🇪"
    default: return "🌐"
    }
}

// MARK: - Widget Configuration

@main
struct WordOfTheDayWidget: Widget {
    let kind: String = "WordOfTheDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WordOfTheDayWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Language Word of the Day")
        .description("Learn a new language word directly from your lock screen or home screen.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryRectangular,
            .accessoryCircular,
            .systemSmall,
            .systemMedium
        ])
    }
}

#Preview(as: .accessoryRectangular) {
    WordOfTheDayWidget()
} vs: {
    let sampleWord = Word(foreignWord: "palabra", translation: "word", pronunciation: "pah-LAH-brah", partOfSpeech: "noun",
                          meaning: "A single distinct element of speech.",
                          exampleForeign: "Esta palabra es muy hermosa.", exampleTranslation: "This word is very beautiful.", language: "Spanish")
    SimpleEntry(date: Date(), word: sampleWord)
}
