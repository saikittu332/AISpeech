import Foundation

/// Network service for API communication
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL: String
    private let session: URLSession
    private var authToken: String?
    
    // MARK: - Initialization
    
    private init() {
        // Configure base URL from environment or use default
        self.baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://api.aispeech.com"
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Authentication
    
    func setAuthToken(_ token: String) {
        self.authToken = token
        KeychainManager.shared.save(token, forKey: "authToken")
    }
    
    func clearAuthToken() {
        self.authToken = nil
        KeychainManager.shared.delete(forKey: "authToken")
    }
    
    func loadAuthToken() {
        self.authToken = KeychainManager.shared.load(forKey: "authToken")
    }
    
    // MARK: - Generic Request Method
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Add body
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        Logger.shared.debug("Request: \(method.rawValue) \(url.absoluteString)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        Logger.shared.debug("Response: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorResponse.message)
            }
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            Logger.shared.error("Decoding error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: - Supporting Types

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case serverError(String)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

struct ErrorResponse: Codable {
    let message: String
    let code: String?
}
