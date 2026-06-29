import SwiftUI

@main
struct WordOfTheDayApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MainDashboardView()
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }
    }
}
