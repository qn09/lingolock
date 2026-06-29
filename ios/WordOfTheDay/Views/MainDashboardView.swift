import SwiftUI
import AVFoundation

struct MainDashboardView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isCardFlipped = false
    @State private var animateWord = false
    
    var currentWord: Word {
        VocabularyData.getWordOfTheDay(for: settings.selectedLanguage)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(settings.selectedLanguage.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                        
                        Text("Word of the Day")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    // Streak or Progress Indicator
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("5 Days")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Word Card Panel
                VStack(spacing: 20) {
                    HStack {
                        Text(currentWord.partOfSpeech.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                settings.toggleFavorite(currentWord)
                            }
                        }) {
                            Image(systemName: settings.isFavorited(currentWord) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(settings.isFavorited(currentWord) ? .yellow : .secondary)
                                .font(.title3)
                        }
                    }
                    
                    // Main Foreign Word
                    VStack(spacing: 8) {
                        Text(currentWord.foreignWord)
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .scaleEffect(animateWord ? 1.0 : 0.95)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    animateWord = true
                                }
                            }
                        
                        Text("/ \(currentWord.pronunciation) /")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 16)
                    
                    // Speak Button
                    Button(action: speakWord) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Listen")
                        }
                        .fontWeight(.medium)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Meaning & Translation
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TRANSLATION")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(currentWord.translation)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MEANING")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(currentWord.meaning)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 10)
                .padding(.horizontal)
                
                // Example Sentence Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Example Sentence")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(currentWord.exampleForeign)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .italic()
                        
                        Text(currentWord.exampleTranslation)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // Lockscreen Tip Card
                HStack(spacing: 16) {
                    Image(systemName: "iphone.smart-button")
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add to Lock Screen")
                            .font(.headline)
                        Text("Learn effortlessly by seeing this word every time you check your phone.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
    }
    
    private func speakWord() {
        let utterance = AVSpeechUtterance(string: currentWord.foreignWord)
        
        // Map language name to BCP 47 code
        switch settings.selectedLanguage {
        case "Spanish":
            utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        case "French":
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        case "Japanese":
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        case "German":
            utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        default:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        utterance.rate = 0.5 // Slower speed for clear learning
        
        // Stop current speech if speaking, then play new one
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }
}

struct MainDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainDashboardView()
    }
}
