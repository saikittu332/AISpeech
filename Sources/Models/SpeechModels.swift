import Foundation

/// Speech recognition result model
struct SpeechRecognitionResult: Identifiable {
    let id: UUID
    let transcript: String
    let confidence: Float
    let timestamp: Date
    let duration: TimeInterval
    let language: String
    
    init(
        id: UUID = UUID(),
        transcript: String,
        confidence: Float,
        timestamp: Date = Date(),
        duration: TimeInterval = 0,
        language: String = "en-US"
    ) {
        self.id = id
        self.transcript = transcript
        self.confidence = confidence
        self.timestamp = timestamp
        self.duration = duration
        self.language = language
    }
}

/// Audio recording session model
struct AudioSession: Identifiable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var transcripts: [SpeechRecognitionResult]
    var audioFileURL: URL?
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        transcripts: [SpeechRecognitionResult] = [],
        audioFileURL: URL? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.transcripts = transcripts
        self.audioFileURL = audioFileURL
    }
}

/// AI processing result
struct AIProcessingResult: Codable {
    let requestId: String
    let processedText: String
    let sentiment: String?
    let keywords: [String]
    let summary: String?
    let timestamp: Date
}
