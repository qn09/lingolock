import Foundation

public enum GeminiError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case apiError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid Gemini API endpoint URL."
        case .invalidResponse: return "Received invalid response from Gemini servers."
        case .decodingError: return "Failed to decode the JSON vocabulary structure."
        case .apiError(let message): return "Gemini API Error: \(message)"
        }
    }
}

public class GeminiService {
    public static let shared = GeminiService()
    
    private init() {}
    
    /// Fetches a dynamic vocabulary word based on the selected language and skill level.
    public func fetchVocabularyWord(for language: String, apiKey: String, excludeWords: [String] = []) async throws -> Word {
        guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw GeminiError.apiError("API Key is empty.")
        }
        
        let model = Secrets.geminiModel.isEmpty ? "gemini-2.5-flash" : Secrets.geminiModel
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw GeminiError.invalidURL
        }
        
        var excludePrompt = ""
        if !excludeWords.isEmpty {
            excludePrompt = " IMPORTANT: Do not choose any of the following previously generated words: [\(excludeWords.joined(separator: ", "))]. You must select a completely new and unique word."
        }
        
        // Define our prompt instructing the model
        let systemPrompt: String
        if language == "English" {
            systemPrompt = "Generate a high-yield, academic English vocabulary word commonly found in the GRE exam (Graduate Record Examinations) for graduate-level verbal reasoning preparation. Focus on advanced, precise, or challenging words. The 'translation' field should be a 1-3 word simplified synonym. The explanation, meaning, and example sentences should all be in English. Do not use translation languages like Vietnamese.\(excludePrompt)"
        } else {
            systemPrompt = "Generate a useful Japanese vocabulary word (written in Kanji or Kana, e.g. 木漏れ日). The 'translation' field should be the English meaning. The pronunciation should be romaji. The meaning and exampleTranslation should be written in English. The exampleForeign must be in Japanese.\(excludePrompt)"
        }
        
        // Form the JSON payload including the strict responseSchema constraint
        let requestPayload: [String: Any] = [
            "contents": [
                ["parts": [["text": systemPrompt]]]
            ],
            "generationConfig": [
                "responseMimeType": "application/json",
                "responseSchema": [
                    "type": "OBJECT",
                    "properties": [
                        "foreignWord": ["type": "STRING"],
                        "translation": ["type": "STRING"],
                        "pronunciation": ["type": "STRING"],
                        "partOfSpeech": ["type": "STRING"],
                        "meaning": ["type": "STRING"],
                        "exampleForeign": ["type": "STRING"],
                        "exampleTranslation": ["type": "STRING"],
                        "language": ["type": "STRING"]
                    ],
                    "required": [
                        "foreignWord", "translation", "pronunciation", "partOfSpeech", 
                        "meaning", "exampleForeign", "exampleTranslation", "language"
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestPayload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorDetails = errorJson["error"] as? [String: Any],
               let errorMessage = errorDetails["message"] as? String {
                throw GeminiError.apiError(errorMessage)
            }
            throw GeminiError.invalidResponse
        }
        
        // Decode the outer Gemini response envelope, then extract the text field
        return try decodeWord(from: data)
    }
    
    private func decodeWord(from data: Data) throws -> Word {
        let decoder = JSONDecoder()
        
        struct GeminiEnvelope: Decodable {
            let candidates: [Candidate]
            
            struct Candidate: Decodable {
                let content: Content
                
                struct Content: Decodable {
                    let parts: [Part]
                    
                    struct Part: Decodable {
                        let text: String
                    }
                }
            }
        }
        
        let envelope = try decoder.decode(GeminiEnvelope.self, from: data)
        guard let rawText = envelope.candidates.first?.content.parts.first?.text,
              let textData = rawText.data(using: .utf8) else {
            throw GeminiError.decodingError
        }
        
        // Decode the inner JSON schema directly into our Word struct
        let word = try decoder.decode(Word.self, from: textData)
        return word
    }
}
