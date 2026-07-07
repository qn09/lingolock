@preconcurrency import WidgetKit
import SwiftUI
import Shared

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
        let currentDate = Date()

        if context.isPreview {
            let sampleWord = Word(foreignWord: "serendipity", pronunciation: "seh-ren-DIP-i-tee", partOfSpeech: "noun",
                                  meaning: "The occurrence and development of events by chance in a happy or beneficial way.",
                                  exampleForeign: "Meeting my old friend at the airport was pure serendipity.", language: language)
            completion(SimpleEntry(date: currentDate, word: sampleWord))
            return
        }

        // Try cached word first
        if let savedWord = AppSettings.shared.getSavedWord(for: currentDate, language: language) {
            completion(SimpleEntry(date: currentDate, word: savedWord))
            return
        }

        // Fetch from Firebase - use nonisolated(unsafe) to bridge the non-Sendable completion
        nonisolated(unsafe) let cb = completion
        nonisolated(unsafe) let lang = language
        nonisolated(unsafe) let date = currentDate
        Task {
            let word = await fetchWordAsync(for: lang, date: date)
            cb(SimpleEntry(date: date, word: word))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let language = getSelectedLanguage()
        let currentDate = Date()
        let calendar = Calendar.current

        // Try cached word first for a fast path
        if let savedWord = AppSettings.shared.getSavedWord(for: currentDate, language: language) {
            let timeline = buildTimeline(todayWord: savedWord, language: language, currentDate: currentDate, calendar: calendar)
            completion(timeline)
            return
        }

        // Need to fetch - use nonisolated(unsafe) to bridge the non-Sendable completion
        nonisolated(unsafe) let cb = completion
        nonisolated(unsafe) let lang = language
        nonisolated(unsafe) let date = currentDate
        nonisolated(unsafe) let cal = calendar
        Task {
            let word = await fetchWordAsync(for: lang, date: date)
            let timeline = buildTimeline(todayWord: word, language: lang, currentDate: date, calendar: cal)
            cb(timeline)
        }
    }

    private func buildTimeline(todayWord: Word, language: String, currentDate: Date, calendar: Calendar) -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        entries.append(SimpleEntry(date: currentDate, word: todayWord))

        for dayOffset in 1..<3 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else { continue }
            let midnightDate = calendar.startOfDay(for: entryDate)

            if let savedWord = AppSettings.shared.getSavedWord(for: midnightDate, language: language) {
                entries.append(SimpleEntry(date: midnightDate, word: savedWord))
            } else {
                entries.append(SimpleEntry(date: midnightDate, word: todayWord))
            }
        }

        let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        let nextMidnight = calendar.startOfDay(for: tomorrow)
        return Timeline(entries: entries, policy: .after(nextMidnight))
    }

    /// Async helper that fetches a word from Firebase and saves it, or returns a fallback
    private func fetchWordAsync(for language: String, date: Date) async -> Word {
        if let fetchedWord = await VocabularyData.fetchWordRESTAsync(for: language, date: date) {
            AppSettings.shared.saveWord(fetchedWord, for: date, language: language)
            return fetchedWord
        }
        return Word(
            foreignWord: "LingoLock \(language)",
            pronunciation: "...",
            partOfSpeech: "noun",
            meaning: "Unable to fetch word. Check internet connection.",
            exampleForeign: "...",
            language: language
        )
    }

    private func getSelectedLanguage() -> String {
        let defaults = AppGroupResolver.sharedDefaults
        return defaults?.string(forKey: "selected_language") ?? "English"
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
            let displayTranslation = word.displayTranslation
            Text("\(word.foreignWord)" + (displayTranslation.isEmpty ? "" : " - \(displayTranslation)"))
                .fontWeight(.semibold)
                .widgetAccentable()
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
                    .widgetAccentable()
            }

            if !word.displayPronunciation.isEmpty {
                Text(word.displayPronunciation)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .italic()
            }

            Spacer(minLength: 0)

            let displayTranslation = word.displayTranslation
            if !displayTranslation.isEmpty {
                Text(displayTranslation)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .widgetAccentable()
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
                .widgetAccentable()
            VStack(spacing: 2) {
                Text(String(word.foreignWord.prefix(3)).capitalized)
                    .font(.system(size: 10, weight: .bold))
                    .widgetAccentable()
            }
        }
    }
}

// MARK: - Theme

enum WidgetTheme {
    static let primaryAccent = Color(red: 0.13, green: 0.38, blue: 0.88)
    static let secondaryAccent = Color(red: 0.95, green: 0.45, blue: 0.16)
    static let softAccent = Color(red: 0.12, green: 0.58, blue: 0.47)
    static let homeBackground = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 1.0, green: 0.95, blue: 0.89)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
// MARK: - Home Screen Widgets

struct SmallWidgetView: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(word.partOfSpeech.lowercased())
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(WidgetTheme.secondaryAccent.opacity(0.14))
                    .foregroundColor(WidgetTheme.secondaryAccent)
                    .cornerRadius(4)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(word.foreignWord)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(WidgetTheme.primaryAccent)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                if !word.displayPronunciation.isEmpty {
                    Text(word.displayPronunciation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }

                let displayTranslation = word.displayTranslation
                if !displayTranslation.isEmpty {
                    Text(displayTranslation)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text("Tap to reveal meaning")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(WidgetTheme.softAccent)
                .tracking(0.5)
        }
        .padding()
        .background(WidgetTheme.homeBackground)
    }
}

struct MediumWidgetView: View {
    let word: Word

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("LingoLock")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(WidgetTheme.softAccent)
                    .tracking(0.5)

                Spacer(minLength: 0)

                Text(word.foreignWord)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(WidgetTheme.primaryAccent)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                if !word.displayPronunciation.isEmpty {
                    Text(word.displayPronunciation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }

                let displayTranslation = word.displayTranslation
                if !displayTranslation.isEmpty {
                    Text(displayTranslation)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                } else {
                    Text("Tap to reveal meaning")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("EXAMPLE SENTENCE")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(WidgetTheme.secondaryAccent)

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
        .background(WidgetTheme.homeBackground)
    }
}

// MARK: - Widget Configuration

extension View {
    @ViewBuilder
    func widgetBackground() -> some View {
        if #available(iOS 17.0, *) {
            self.applyContainerBackground()
        } else {
            self
                .padding()
                .background()
        }
    }
}

@available(iOS 17.0, *)
extension View {
    func applyContainerBackground() -> some View {
        self.containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct WordOfTheDayWidget: Widget {
    let kind: String = "WordOfTheDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WordOfTheDayWidgetEntryView(entry: entry)
                .widgetBackground()
        }
        .configurationDisplayName("LingoLock")
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
