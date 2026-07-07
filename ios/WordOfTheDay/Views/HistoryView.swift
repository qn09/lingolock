import SwiftUI
import Shared

struct HistoryView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var searchText = ""
    
    var historyWords: [Word] {
        VocabularyData.getHistory(for: settings.selectedLanguage, limit: 30)
    }
    
    var filteredWords: [Word] {
        if searchText.isEmpty {
            return historyWords
        } else {
            return historyWords.filter {
                $0.foreignWord.localizedCaseInsensitiveContains(searchText) ||
                $0.meaning.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Word History")) {
                    if filteredWords.isEmpty {
                        Text("No words found matching the search.")
                            .foregroundColor(.secondary)
                            .italic()
                            .padding()
                    } else {
                        ForEach(filteredWords) { word in
                             NavigationLink(destination: WordDetailView(word: word)) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(word.foreignWord)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text(word.meaning)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    if settings.isFavorited(word) {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                    }
                                    
                                    Text(word.partOfSpeech.lowercased())
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search learned words")
            .navigationTitle("History")
        }
    }
}

// Small detail view for history words
struct WordDetailView: View {
    let word: Word
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text(word.partOfSpeech.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Text(word.foreignWord)
                    .font(.system(size: 40, weight: .bold, design: .serif))
                
                Text("/ \(word.pronunciation) /")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .italic()
            }
            .padding(.top, 24)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("MEANING")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text(word.meaning)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("EXAMPLE SENTENCE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text(word.exampleForeign)
                        .font(.body)
                        .italic()
                }
            }
            .padding(24)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    settings.toggleFavorite(word)
                }) {
                    Image(systemName: settings.isFavorited(word) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(settings.isFavorited(word) ? .yellow : .blue)
                }
            }
        }
    }
}
