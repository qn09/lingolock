import SwiftUI
import AVFoundation
import Shared

struct MainDashboardView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isCardFlipped = false
    @State private var animateWord = false
    
    var currentWord: Word {
        // Explicitly depend on dailyAiWords so SwiftUI redraws when it changes
        _ = settings.dailyAiWords
        return VocabularyData.getWordOfTheDay(for: settings.selectedLanguage)
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
                
                // Firebase sync button
                HStack {
                    Image(systemName: "cloud")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("Firebase Connected")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: {
                        VocabularyData.forceGenerateNewWord(for: settings.selectedLanguage)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Sync")
                        }
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -8)
                
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
                        
                        if !currentWord.translation.isEmpty {
                            Text(currentWord.translation)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                        }
                        
                        if !currentWord.formattedPronunciation.isEmpty {
                            Text(currentWord.formattedPronunciation)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding(.vertical, 16)
                    
                    // Speak Button and Next Word Button
                    HStack(spacing: 16) {
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
                        
                        Button(action: {
                            withAnimation {
                                VocabularyData.forceGenerateNewWord(for: settings.selectedLanguage)
                                isCardFlipped = false
                                animateWord = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        animateWord = true
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Đổi từ mới")
                            }
                            .fontWeight(.medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    if isCardFlipped {
                        // Meaning Card
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MEANING")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(currentWord.meaning)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        // Tap to reveal helper
                        VStack(spacing: 8) {
                            Image(systemName: "eye.slash.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Tap Card to Reveal Meaning")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 12)
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 10)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isCardFlipped.toggle()
                    }
                }
                .padding(.horizontal)
                
                // Example Sentence Card
                if isCardFlipped {
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
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
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
        // Clean up the text to speak by removing any text in parentheses
        var stringToSpeak = currentWord.foreignWord
        if let range = stringToSpeak.range(of: " (") {
            stringToSpeak = String(stringToSpeak[..<range.lowerBound])
        } else if let range = stringToSpeak.range(of: "(") {
            stringToSpeak = String(stringToSpeak[..<range.lowerBound])
        }
        
        let utterance = AVSpeechUtterance(string: stringToSpeak.trimmingCharacters(in: .whitespacesAndNewlines))
        
        // Map language name to BCP 47 code
        switch settings.selectedLanguage {
        case "English":
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        case "Japanese":
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        default:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        utterance.rate = 0.5 // Slower speed for clear learning
        
        // Configure AVAudioSession to play audio even when the silent switch is on
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set AVAudioSession category: \(error.localizedDescription)")
        }
        
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
