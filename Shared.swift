import Foundation

enum Shared {
    static let appGroupId = "group.com.assignment.voiceboard"

    enum Keys {
        static let groqApiKey = "groq_api_key"
    }

    enum Groq {
        static let transcriptionURL = URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!
        static let model = "whisper-large-v3-turbo"
    }
}