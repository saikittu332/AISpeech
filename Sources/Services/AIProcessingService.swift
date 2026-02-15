import Foundation

/// Service for AI processing of speech transcripts
class AIProcessingService {
    static let shared = AIProcessingService()
    
    private let networkService = NetworkService.shared
    
    private init() {}
    
    // MARK: - AI Processing Methods
    
    func processTranscript(_ transcript: String) async throws -> AIProcessingResult {
        struct ProcessRequest: Codable {
            let text: String
        }
        
        let request = ProcessRequest(text: transcript)
        let result: AIProcessingResult = try await networkService.request(
            endpoint: "/ai/process",
            method: .post,
            body: request
        )
        
        Logger.shared.info("AI processing completed for transcript")
        return result
    }
    
    func analyzeSentiment(_ text: String) async throws -> String {
        struct SentimentRequest: Codable {
            let text: String
        }
        
        struct SentimentResponse: Codable {
            let sentiment: String
            let confidence: Float
        }
        
        let request = SentimentRequest(text: text)
        let response: SentimentResponse = try await networkService.request(
            endpoint: "/ai/sentiment",
            method: .post,
            body: request
        )
        
        return response.sentiment
    }
    
    func extractKeywords(_ text: String) async throws -> [String] {
        struct KeywordRequest: Codable {
            let text: String
        }
        
        struct KeywordResponse: Codable {
            let keywords: [String]
        }
        
        let request = KeywordRequest(text: text)
        let response: KeywordResponse = try await networkService.request(
            endpoint: "/ai/keywords",
            method: .post,
            body: request
        )
        
        return response.keywords
    }
    
    func generateSummary(_ text: String) async throws -> String {
        struct SummaryRequest: Codable {
            let text: String
            let maxLength: Int?
        }
        
        struct SummaryResponse: Codable {
            let summary: String
        }
        
        let request = SummaryRequest(text: text, maxLength: 100)
        let response: SummaryResponse = try await networkService.request(
            endpoint: "/ai/summary",
            method: .post,
            body: request
        )
        
        return response.summary
    }
    
    // MARK: - Real-time Streaming
    
    func startStreamingSession() async throws -> String {
        struct SessionResponse: Codable {
            let sessionId: String
        }
        
        let response: SessionResponse = try await networkService.request(
            endpoint: "/ai/stream/start",
            method: .post
        )
        
        return response.sessionId
    }
    
    func sendStreamingData(_ sessionId: String, data: String) async throws {
        struct StreamRequest: Codable {
            let sessionId: String
            let data: String
        }
        
        let request = StreamRequest(sessionId: sessionId, data: data)
        let _: EmptyResponse = try await networkService.request(
            endpoint: "/ai/stream/send",
            method: .post,
            body: request
        )
    }
    
    func endStreamingSession(_ sessionId: String) async throws {
        struct EndRequest: Codable {
            let sessionId: String
        }
        
        let request = EndRequest(sessionId: sessionId)
        let _: EmptyResponse = try await networkService.request(
            endpoint: "/ai/stream/end",
            method: .post,
            body: request
        )
    }
}

// MARK: - Supporting Types

struct EmptyResponse: Codable {}
