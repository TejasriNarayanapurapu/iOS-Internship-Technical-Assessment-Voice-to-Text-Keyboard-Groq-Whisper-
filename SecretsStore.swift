import Foundation

final class SecretsStore {
    static let shared = SecretsStore()
    private let defaults = UserDefaults(suiteName: Shared.appGroupId)!

    func saveGroqKey(_ key: String) {
        defaults.set(key.trimmingCharacters(in: .whitespacesAndNewlines), forKey: Shared.Keys.groqApiKey)
    }

    func loadGroqKey() -> String? {
        defaults.string(forKey: Shared.Keys.groqApiKey)
    }
}