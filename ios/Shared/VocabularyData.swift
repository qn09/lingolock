import Foundation

public struct VocabularyData {
    public static let languages = ["Spanish", "French", "Japanese", "German"]
    
    // A robust, high-quality list of starter vocabulary for each language.
    // In a production app, this can be expanded or fetched from an API,
    // but having a built-in fallback database guarantees offline widget reliability.
    public static let words: [String: [Word]] = [
        "Spanish": [
            Word(foreignWord: "palabra", translation: "word", pronunciation: "pah-LAH-brah", partOfSpeech: "noun",
                 meaning: "A single distinct meaningful element of speech or writing.",
                 exampleForeign: "Esta palabra en español es muy hermosa.", exampleTranslation: "This word in Spanish is very beautiful.", language: "Spanish"),
            Word(foreignWord: "crecer", translation: "to grow", pronunciation: "kreh-SEHR", partOfSpeech: "verb",
                 meaning: "To undergo natural development by increasing in size and changing physically.",
                 exampleForeign: "Las flores crecen rápidamente en primavera.", exampleTranslation: "Flowers grow quickly in spring.", language: "Spanish"),
            Word(foreignWord: "amanecer", translation: "dawn", pronunciation: "ah-mah-neh-SEHR", partOfSpeech: "noun",
                 meaning: "The first appearance of light in the sky before sunrise.",
                 exampleForeign: "Me gusta ver el amanecer frente al mar.", exampleTranslation: "I like to watch the dawn in front of the sea.", language: "Spanish"),
            Word(foreignWord: "desafío", translation: "challenge", pronunciation: "deh-sah-FEE-oh", partOfSpeech: "noun",
                 meaning: "A task or situation that tests someone's abilities.",
                 exampleForeign: "Aprender un nuevo idioma es un gran desafío.", exampleTranslation: "Learning a new language is a great challenge.", language: "Spanish"),
            Word(foreignWord: "sonreír", translation: "to smile", pronunciation: "sohn-ray-EER", partOfSpeech: "verb",
                 meaning: "Form one's features into a pleased or kind expression.",
                 exampleForeign: "Ella siempre sonríe cuando está feliz.", exampleTranslation: "She always smiles when she is happy.", language: "Spanish"),
            Word(foreignWord: "mariposa", translation: "butterfly", pronunciation: "mah-ree-POH-sah", partOfSpeech: "noun",
                 meaning: "An insect with broad, often brightly colored wings.",
                 exampleForeign: "La mariposa vuela sobre las flores del jardín.", exampleTranslation: "The butterfly flies over the flowers in the garden.", language: "Spanish"),
            Word(foreignWord: "descubrir", translation: "to discover", pronunciation: "dehs-koo-BREER", partOfSpeech: "verb",
                 meaning: "Find unexpectedly or during a search.",
                 exampleForeign: "Queremos descubrir nuevos lugares este fin de semana.", exampleTranslation: "We want to discover new places this weekend.", language: "Spanish")
        ],
        "French": [
            Word(foreignWord: "espoir", translation: "hope", pronunciation: "ess-pwahr", partOfSpeech: "noun",
                 meaning: "A feeling of expectation and desire for a certain thing to happen.",
                 exampleForeign: "Il y a toujours de l'espoir, même dans les moments difficiles.", exampleTranslation: "There is always hope, even in difficult times.", language: "French"),
            Word(foreignWord: "découvrir", translation: "to discover", pronunciation: "day-koo-vreer", partOfSpeech: "verb",
                 meaning: "To find unexpectedly or acquire knowledge of for the first time.",
                 exampleForeign: "J'adore découvrir de nouvelles cultures.", exampleTranslation: "I love to discover new cultures.", language: "French"),
            Word(foreignWord: "flâner", translation: "to wander / stroll", pronunciation: "flah-nay", partOfSpeech: "verb",
                 meaning: "To lounge or saunter around idly.",
                 exampleForeign: "Nous flânons souvent dans les rues de Paris le dimanche.", exampleTranslation: "We often stroll in the streets of Paris on Sundays.", language: "French"),
            Word(foreignWord: "étoile", translation: "star", pronunciation: "ay-twahl", partOfSpeech: "noun",
                 meaning: "A luminous point in the night sky which is a large, remote incandescent body.",
                 exampleForeign: "Regarde le ciel, il y a beaucoup d'étoiles ce soir.", exampleTranslation: "Look at the sky, there are many stars tonight.", language: "French"),
            Word(foreignWord: "bienveillance", translation: "benevolence / kindness", pronunciation: "byeh-vay-lahns", partOfSpeech: "noun",
                 meaning: "The quality of well-meaning; kindness.",
                 exampleForeign: "Sa bienveillance envers les autres est admirable.", exampleTranslation: "Her kindness towards others is admirable.", language: "French"),
            Word(foreignWord: "éphémère", translation: "ephemeral", pronunciation: "ay-fay-mair", partOfSpeech: "adjective",
                 meaning: "Lasting for a very short time.",
                 exampleForeign: "La beauté des fleurs de cerisier est éphémère.", exampleTranslation: "The beauty of cherry blossoms is ephemeral.", language: "French"),
            Word(foreignWord: "voyager", translation: "to travel", pronunciation: "vwah-yah-jay", partOfSpeech: "verb",
                 meaning: "Go on a journey, typically of some length or abroad.",
                 exampleForeign: "Voyager permet d'ouvrir son esprit.", exampleTranslation: "Traveling allows one to open their mind.", language: "French")
        ],
        "Japanese": [
            Word(foreignWord: "Komorebi (木漏れ日)", translation: "sunlight filtering through trees", pronunciation: "ko-mo-reh-bee", partOfSpeech: "noun",
                 meaning: "The sunlight that filters through the leaves of trees.",
                 exampleForeign: "森を歩くと、美しい木漏れ日が見られます。", exampleTranslation: "Walking through the forest, you can see beautiful sunlight filtering through trees.", language: "Japanese"),
            Word(foreignWord: "Kintsugi (金継ぎ)", translation: "golden pottery repair", pronunciation: "keen-tsoo-gee", partOfSpeech: "noun",
                 meaning: "The Japanese art of repairing broken pottery with lacquer dusted or mixed with powdered gold.",
                 exampleForeign: "金継ぎは、壊れたものに新しい命を吹き込みます。", exampleTranslation: "Kintsugi breathes new life into broken objects.", language: "Japanese"),
            Word(foreignWord: "Ikigai (生き甲斐)", translation: "a reason for being", pronunciation: "ee-kee-guy", partOfSpeech: "noun",
                 meaning: "A concept referring to something that gives a person a sense of purpose or a reason for living.",
                 exampleForeign: "私の生き甲斐は、人々の役に立つことです。", exampleTranslation: "My reason for being is to be useful to people.", language: "Japanese"),
            Word(foreignWord: "Kaizen (改善)", translation: "continuous improvement", pronunciation: "kye-zen", partOfSpeech: "noun",
                 meaning: "A Japanese business philosophy of continuous improvement of working practices and personal efficiency.",
                 exampleForeign: "毎日少しずつ業務を改善していきます。", exampleTranslation: "We will improve our business operations little by little every day.", language: "Japanese"),
            Word(foreignWord: "Natsukashii (懐かしい)", translation: "nostalgic / dear", pronunciation: "nah-tsoo-kah-shee", partOfSpeech: "adjective",
                 meaning: "Bringing back fond memories of the past; nostalgic.",
                 exampleForeign: "この古いアルバムを見ると、子供の頃が懐かしいです。", exampleTranslation: "Looking at this old album makes me feel nostalgic for my childhood.", language: "Japanese"),
            Word(foreignWord: "Komorebi (木漏れ日)", translation: "sunlight through trees", pronunciation: "ko-mo-reh-bee", partOfSpeech: "noun",
                 meaning: "Sunlight filtering through the leaves of trees.",
                 exampleForeign: "木漏れ日を浴びながら読書をするのが好きです。", exampleTranslation: "I like to read while bathing in the sunlight filtering through trees.", language: "Japanese"),
            Word(foreignWord: "Yūgen (幽玄)", translation: "profound grace / mystery", pronunciation: "yoo-gen", partOfSpeech: "noun",
                 meaning: "An important concept in traditional Japanese aesthetics, meaning a profound, mysterious sense of beauty.",
                 exampleForeign: "この日本庭園には幽玄の美があります。", exampleTranslation: "This Japanese garden has a profound, mysterious beauty.", language: "Japanese")
        ],
        "German": [
            Word(foreignWord: "Fernweh", translation: "longing to travel", pronunciation: "FEHRN-vay", partOfSpeech: "noun",
                 meaning: "A longing for distant places; the opposite of homesickness (Heimweh).",
                 exampleForeign: "Im Winter packt mich immer das Fernweh.", exampleTranslation: "In winter I am always seized by the longing to travel.", language: "German"),
            Word(foreignWord: "Sehnsucht", translation: "nostalgic yearning", pronunciation: "ZAYN-zookht", partOfSpeech: "noun",
                 meaning: "A deep longing or yearning for something distant or intangible.",
                 exampleForeign: "Er hat eine große Sehnsucht nach der Heimat.", exampleTranslation: "He has a great yearning for his homeland.", language: "German"),
            Word(foreignWord: "Zeitgeist", translation: "spirit of the time", pronunciation: "TSYTE-gyste", partOfSpeech: "noun",
                 meaning: "The defining spirit or mood of a particular period of history as shown by the ideas and beliefs of the time.",
                 exampleForeign: "Dieser Film fängt den Zeitgeist der Neunziger perfekt ein.", exampleTranslation: "This movie perfectly captures the spirit of the nineties.", language: "German"),
            Word(foreignWord: "Schadenfreude", translation: "harm-joy", pronunciation: "SHAH-den-froy-deh", partOfSpeech: "noun",
                 meaning: "Pleasure derived by someone from another person's misfortune.",
                 exampleForeign: "Es liegt eine gewisse Schadenfreude in seinem Lächeln.", exampleTranslation: "There is a certain Schadenfreude in his smile.", language: "German"),
            Word(foreignWord: "Gemütlichkeit", translation: "coziness / comfort", pronunciation: "geh-MOOT-likh-kyte", partOfSpeech: "noun",
                 meaning: "A state of warmth, friendliness, and good cheer, inducing a cozy atmosphere.",
                 exampleForeign: "Das kleine Café strahlte eine wunderbare Gemütlichkeit aus.", exampleTranslation: "The small café radiated a wonderful coziness.", language: "German"),
            Word(foreignWord: "Fernweh", translation: "longing for far places", pronunciation: "FEHRN-vay", partOfSpeech: "noun",
                 meaning: "A desire to travel, farsickness.",
                 exampleForeign: "Bilder von Stränden wecken mein Fernweh.", exampleTranslation: "Pictures of beaches awaken my longing to travel.", language: "German"),
            Word(foreignWord: "Weltschmerz", translation: "world-weariness", pronunciation: "VELT-shmerts", partOfSpeech: "noun",
                 meaning: "A feeling of melancholy and world-weariness, caused by a comparison of the actual state of the world with an ideal state.",
                 exampleForeign: "Manchmal überkommt mich ein tiefer Weltschmerz.", exampleTranslation: "Sometimes a deep world-weariness overcomes me.", language: "German")
        ]
    ]
    
    /// Computes the word of the day for a specific language and date.
    /// By using date components, we guarantee that all devices running the app
    /// and widgets show the exact same word for a given day, and it rotates automatically.
    public static func getWordOfTheDay(for language: String, date: Date = Date()) -> Word {
        let selectedLanguage = languages.contains(language) ? language : "Spanish"
        let languageWords = words[selectedLanguage] ?? words["Spanish"]!
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % languageWords.count
        
        return languageWords[index]
    }
    
    /// Retrieves a historical list of words up to the current date.
    /// Helpful to simulate learning progress.
    public static func getHistory(for language: String, limit: Int = 10, relativeTo date: Date = Date()) -> [Word] {
        let selectedLanguage = languages.contains(language) ? language : "Spanish"
        let languageWords = words[selectedLanguage] ?? words["Spanish"]!
        
        var history: [Word] = []
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        // Let's retrieve the words of the last N days
        for i in 0..<min(limit, dayOfYear) {
            let targetDay = dayOfYear - i
            let index = (targetDay - 1) % languageWords.count
            let word = languageWords[index]
            history.append(word)
        }
        
        return history
    }
}
