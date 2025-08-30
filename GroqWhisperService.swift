import Foundation

struct TranscriptionResult: Decodable { let text: String }

enum GroqError: Error, LocalizedError {
    case missingAPIKey
    case invalidResponse
    case http(Int)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "Missing Groq API key. Please open the container app and save your key."
        case .invalidResponse: return "Invalid server response."
        case .http(let code): return "Network error (HTTP \(code))."
        case .underlying(let e): return e.localizedDescription
        }
    }
}

final class GroqWhisperService {
    private let apiKey: String?
    init(apiKey: String?) { self.apiKey = apiKey }

    func transcribe(fileURL: URL, language: String? = nil) async throws -> String {
        guard let apiKey, !apiKey.isEmpty else { throw GroqError.missingAPIKey }

        var req = URLRequest(url: Shared.Groq.transcriptionURL)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = try makeMultipartBody(boundary: boundary, fileURL: fileURL, language: language)
        req.httpBody = body

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw GroqError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw GroqError.http(http.statusCode) }

        if let result = try? JSONDecoder().decode(TranscriptionResult.self, from: data) {
            return result.text
        }
        if let text = String(data: data, encoding: .utf8) { return text }
        throw GroqError.invalidResponse
    }

    private func makeMultipartBody(boundary: String, fileURL: URL, language: String?) throws -> Data {
        var body = Data()
        func append(_ s: String) { body.append(s.data(using: .utf8)!) }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        append(Shared.Groq.model + "\r\n")

        if let language, !language.isEmpty {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"language\"\r\n\r\n")
            append(language + "\r\n")
        }

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n")
        append("text\r\n")

        let filename = fileURL.lastPathComponent
        let fileData = try Data(contentsOf: fileURL)
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: audio/m4a\r\n\r\n")
        body.append(fileData)
        append("\r\n")

        append("--\(boundary)--\r\n")
        return body
    }
}