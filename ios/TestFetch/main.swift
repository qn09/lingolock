import Foundation
import Shared

print("Testing Firestore REST fetch for Japanese...")
let semaphore = DispatchSemaphore(value: 0)

Task {
    if let word = await VocabularyData.fetchWordRESTAsync(for: "Japanese", date: Date()) {
        print("\n=== SUCCESS ===")
        print("Foreign Word: \(word.foreignWord)")
        print("Display Translation: \(word.displayTranslation)")
        print("Native Meaning: \(word.nativeMeaning)")
        print("English Meaning: \(word.englishMeaning)")
        print("Pronunciation: \(word.pronunciation)")
        print("Display Pronunciation: \(word.displayPronunciation)")
        print("Romanization: \(word.romanization)")
        print("Display Meaning: \(word.displayMeaning)")
        print("Example: \(word.exampleForeign)")
        print("Example Translation: \(word.exampleTranslation)")
        print("Level: \(word.level)")
        let tags = word.tags.joined(separator: ", ")
        print("Tags: \(tags)")
        print("===============\n")
    } else {
        print("\n=== FAILED to fetch Japanese word! ===\n")
    }
    semaphore.signal()
}

semaphore.wait()
print("Test completed.")
