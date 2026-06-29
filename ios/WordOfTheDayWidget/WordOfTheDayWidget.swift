import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        let sampleWord = Word(foreignWord: "serendipity", pronunciation: "seh-ren-DIP-i-tee", partOfSpeech: "noun",
                              meaning: "The occurrence and development of events by chance in a happy or beneficial way.",
                              exampleForeign: "Meeting my old friend at the airport was pure serendipity.", language: "English")
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
        
        for dayOffset in 0..<3 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else { continue }
            let midnightDate = calendar.startOfDay(for: entryDate)
            
            let wordForDay = getOfflineWord(for: language, date: midnightDate)
            
            let triggerDate = dayOffset == 0 ? currentDate : midnightDate
            let entry = SimpleEntry(date: triggerDate, word: wordForDay)
            entries.append(entry)
        }

        let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        let nextMidnight = calendar.startOfDay(for: tomorrow)
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
    
    private func getSelectedLanguage() -> String {
        let appGroupId = "group.com.language.wordoftheday"
        let defaults = UserDefaults(suiteName: appGroupId)
        return defaults?.string(forKey: "selected_language") ?? "English"
    }
    
    private func getOfflineWord(for language: String, date: Date) -> Word {
        return VocabularyData.getWordOfTheDay(for: language, date: date)
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
            Text("\(word.foreignWord)" + (word.translation.isEmpty ? "" : " - \(word.translation)"))
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
            
            if !word.formattedPronunciation.isEmpty {
                Text(word.formattedPronunciation)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Spacer(minLength: 0)
            
            if !word.translation.isEmpty {
                Text(word.translation)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
            } else {
                Text(word.partOfSpeech.capitalized)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
            }
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
                
                if !word.formattedPronunciation.isEmpty {
                    Text(word.formattedPronunciation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                if !word.translation.isEmpty {
                    Text(word.translation)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text("Tap to reveal meaning")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.blue)
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
                
                if !word.formattedPronunciation.isEmpty {
                    Text(word.formattedPronunciation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                
                if !word.translation.isEmpty {
                    Text(word.translation)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .lineLimit(2)
                } else {
                    Text("Tap to reveal meaning")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("EXAMPLE SENTENCE")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                Text("Tap widget to open LingoLock and view example sentence usage.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .italic()
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
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
    case "English": return "🇬🇧"
    case "Japanese": return "🇯🇵"
    default: return "🌐"
    }
}

// MARK: - Widget Configuration

@main
struct WordOfTheDayWidget: Widget {
    let kind: String = "WordOfTheDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                WordOfTheDayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WordOfTheDayWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
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

struct WordOfTheDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(foreignWord: "serendipity", pronunciation: "seh-ren-DIP-i-tee", partOfSpeech: "noun",
                              meaning: "The occurrence and development of events by chance in a happy or beneficial way.",
                              exampleForeign: "Meeting my old friend at the airport was pure serendipity.", language: "English")
        WordOfTheDayWidgetEntryView(entry: SimpleEntry(date: Date(), word: sampleWord))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
