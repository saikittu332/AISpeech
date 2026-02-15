import SwiftUI
import Combine

/// Global application state management
class AppState: ObservableObject {
    // MARK: - Published Properties
    
    @Published var colorScheme: ColorScheme?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - User Preferences
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            colorScheme = isDarkMode ? .dark : .light
        }
    }
    
    @AppStorage("fontSize") var fontSize: Double = 16.0
    @AppStorage("enableHaptics") var enableHaptics: Bool = true
    @AppStorage("enableNotifications") var enableNotifications: Bool = true
    
    // MARK: - Initialization
    
    init() {
        colorScheme = isDarkMode ? .dark : .light
    }
    
    // MARK: - Methods
    
    func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
}
