import Foundation

/// Constants used throughout the app
enum Constants {
    
    // MARK: - App Info
    
    enum App {
        static let name = "AISpeech"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    // MARK: - API
    
    enum API {
        static let timeout: TimeInterval = 30
        static let maxRetries = 3
    }
    
    // MARK: - UI
    
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let spacing: CGFloat = 16
        static let padding: CGFloat = 20
        static let animationDuration: Double = 0.3
    }
    
    // MARK: - Audio
    
    enum Audio {
        static let sampleRate: Double = 44100
        static let maxRecordingDuration: TimeInterval = 300 // 5 minutes
        static let minRecordingDuration: TimeInterval = 0.5
    }
    
    // MARK: - Speech
    
    enum Speech {
        static let defaultLanguage = "en-US"
        static let supportedLanguages = ["en-US", "es-ES", "fr-FR", "de-DE", "it-IT", "ja-JP", "ko-KR", "zh-CN"]
        static let defaultSpeechRate: Float = 0.5
        static let minConfidence: Float = 0.5
    }
    
    // MARK: - Storage
    
    enum Storage {
        static let maxTranscriptHistory = 100
        static let cacheExpirationDays = 7
    }
    
    // MARK: - Validation
    
    enum Validation {
        static let minPasswordLength = 8
        static let minUsernameLength = 3
        static let maxUsernameLength = 20
    }
}
