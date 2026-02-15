import Foundation

/// User model for authentication and user data
struct User: Codable, Identifiable {
    let id: UUID
    var email: String
    var username: String
    var fullName: String?
    var profileImageURL: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        email: String,
        username: String,
        fullName: String? = nil,
        profileImageURL: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.fullName = fullName
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - API Response Models

struct LoginResponse: Codable {
    let user: User
    let token: String
    let refreshToken: String?
}

struct RegisterResponse: Codable {
    let user: User
    let token: String
}
