import Foundation
import Combine

/// ViewModel for authentication and onboarding
class AuthenticationViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isAuthenticated = false
    @Published var hasCompletedOnboarding = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    // Form fields
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // MARK: - Private Properties
    
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        return password.count >= Constants.Validation.minPasswordLength
    }
    
    var doPasswordsMatch: Bool {
        return password == confirmPassword
    }
    
    var canLogin: Bool {
        return isEmailValid && !password.isEmpty
    }
    
    var canRegister: Bool {
        return isEmailValid && isPasswordValid && doPasswordsMatch && !username.isEmpty
    }
    
    // MARK: - Initialization
    
    init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Methods
    
    func checkAuthenticationStatus() {
        isAuthenticated = authService.isAuthenticated()
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if isAuthenticated {
            currentUser = authService.loadUser()
        }
        
        Logger.shared.info("Authentication status: \(isAuthenticated), Onboarding: \(hasCompletedOnboarding)")
    }
    
    func login() {
        guard canLogin else {
            errorMessage = "Please enter valid credentials"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await authService.login(email: email, password: password)
                
                await MainActor.run {
                    self.currentUser = response.user
                    self.isAuthenticated = true
                    self.isLoading = false
                    Logger.shared.info("Login successful for user: \(response.user.email)")
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    Logger.shared.error("Login failed: \(error)")
                }
            }
        }
    }
    
    func register() {
        guard canRegister else {
            errorMessage = "Please fill in all fields correctly"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await authService.register(
                    email: email,
                    username: username,
                    password: password
                )
                
                await MainActor.run {
                    self.currentUser = response.user
                    self.isAuthenticated = true
                    self.isLoading = false
                    Logger.shared.info("Registration successful for user: \(response.user.email)")
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    Logger.shared.error("Registration failed: \(error)")
                }
            }
        }
    }
    
    func logout() {
        authService.logout()
        isAuthenticated = false
        currentUser = nil
        email = ""
        password = ""
        confirmPassword = ""
        username = ""
        
        Logger.shared.info("User logged out")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
        Logger.shared.info("Onboarding completed")
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
}
