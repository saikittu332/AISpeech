import Foundation

/// Authentication service for user login/logout
class AuthenticationService {
    static let shared = AuthenticationService()
    
    private let networkService = NetworkService.shared
    private let keychainManager = KeychainManager.shared
    
    private init() {}
    
    // MARK: - Authentication Methods
    
    func login(email: String, password: String) async throws -> LoginResponse {
        struct LoginRequest: Codable {
            let email: String
            let password: String
        }
        
        let request = LoginRequest(email: email, password: password)
        let response: LoginResponse = try await networkService.request(
            endpoint: "/auth/login",
            method: .post,
            body: request
        )
        
        // Save token
        networkService.setAuthToken(response.token)
        if let refreshToken = response.refreshToken {
            keychainManager.save(refreshToken, forKey: "refreshToken")
        }
        
        // Save user data
        saveUser(response.user)
        
        return response
    }
    
    func register(email: String, username: String, password: String) async throws -> RegisterResponse {
        struct RegisterRequest: Codable {
            let email: String
            let username: String
            let password: String
        }
        
        let request = RegisterRequest(email: email, username: username, password: password)
        let response: RegisterResponse = try await networkService.request(
            endpoint: "/auth/register",
            method: .post,
            body: request
        )
        
        // Save token
        networkService.setAuthToken(response.token)
        
        // Save user data
        saveUser(response.user)
        
        return response
    }
    
    func logout() {
        networkService.clearAuthToken()
        keychainManager.delete(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    func refreshToken() async throws -> String {
        guard let refreshToken = keychainManager.load(forKey: "refreshToken") else {
            throw AuthError.noRefreshToken
        }
        
        struct RefreshRequest: Codable {
            let refreshToken: String
        }
        
        struct RefreshResponse: Codable {
            let token: String
        }
        
        let request = RefreshRequest(refreshToken: refreshToken)
        let response: RefreshResponse = try await networkService.request(
            endpoint: "/auth/refresh",
            method: .post,
            body: request
        )
        
        networkService.setAuthToken(response.token)
        return response.token
    }
    
    // MARK: - User Management
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
    
    func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "currentUser") else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    func isAuthenticated() -> Bool {
        return keychainManager.load(forKey: "authToken") != nil
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case noRefreshToken
    case invalidCredentials
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .noRefreshToken:
            return "No refresh token available"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "User not found"
        }
    }
}
