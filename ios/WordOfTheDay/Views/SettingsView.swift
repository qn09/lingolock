import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning Preferences")) {
                    Picker("Target Language", selection: $settings.selectedLanguage) {
                        ForEach(VocabularyData.languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                // Gemini configuration removed for Firebase
                Section(header: Text("How to Add to Lock Screen")) {
                    VStack(alignment: .leading, spacing: 10) {
                        InstructionRow(step: "1", text: "Touch and hold the Lock Screen until the Customize button appears, then tap Customize.")
                        InstructionRow(step: "2", text: "Select Lock Screen (on the left side).")
                        InstructionRow(step: "3", text: "Tap the box below the time to open the widget gallery.")
                        InstructionRow(step: "4", text: "Scroll down and select 'WordOfTheDay', then tap or drag the rectangular or inline widget to add it.")
                        InstructionRow(step: "5", text: "Tap Done in the top-right corner to save.")
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Technical Setup (App Groups)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("App Group Active")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        
                        Text("Identifier: \(AppSettings.appGroupId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                        
                        Text("This shared container syncs vocabulary updates seamlessly from the app to your Lock Screen widget in background.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Language Learner")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct InstructionRow: View {
    let step: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(step)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
