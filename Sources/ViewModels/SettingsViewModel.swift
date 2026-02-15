import Foundation
import Combine

/// ViewModel for settings and user preferences
class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    @Published var fontSize: Double {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
    }
    
    @Published var enableHaptics: Bool {
        didSet {
            UserDefaults.standard.set(enableHaptics, forKey: "enableHaptics")
        }
    }
    
    @Published var enableNotifications: Bool {
        didSet {
            UserDefaults.standard.set(enableNotifications, forKey: "enableNotifications")
        }
    }
    
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }
    
    @Published var speechRate: Float {
        didSet {
            UserDefaults.standard.set(speechRate, forKey: "speechRate")
        }
    }
    
    @Published var autoProcessWithAI: Bool {
        didSet {
            UserDefaults.standard.set(autoProcessWithAI, forKey: "autoProcessWithAI")
        }
    }
    
    // MARK: - Initialization
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.fontSize = UserDefaults.standard.double(forKey: "fontSize") != 0 
            ? UserDefaults.standard.double(forKey: "fontSize") 
            : 16.0
        self.enableHaptics = UserDefaults.standard.object(forKey: "enableHaptics") as? Bool ?? true
        self.enableNotifications = UserDefaults.standard.object(forKey: "enableNotifications") as? Bool ?? true
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Constants.Speech.defaultLanguage
        self.speechRate = UserDefaults.standard.object(forKey: "speechRate") as? Float ?? Constants.Speech.defaultSpeechRate
        self.autoProcessWithAI = UserDefaults.standard.bool(forKey: "autoProcessWithAI")
    }
    
    // MARK: - Methods
    
    func resetToDefaults() {
        isDarkMode = false
        fontSize = 16.0
        enableHaptics = true
        enableNotifications = true
        selectedLanguage = Constants.Speech.defaultLanguage
        speechRate = Constants.Speech.defaultSpeechRate
        autoProcessWithAI = false
        
        Logger.shared.info("Settings reset to defaults")
    }
    
    func exportSettings() -> [String: Any] {
        return [
            "isDarkMode": isDarkMode,
            "fontSize": fontSize,
            "enableHaptics": enableHaptics,
            "enableNotifications": enableNotifications,
            "selectedLanguage": selectedLanguage,
            "speechRate": speechRate,
            "autoProcessWithAI": autoProcessWithAI
        ]
    }
    
    func importSettings(_ settings: [String: Any]) {
        if let darkMode = settings["isDarkMode"] as? Bool {
            isDarkMode = darkMode
        }
        if let size = settings["fontSize"] as? Double {
            fontSize = size
        }
        if let haptics = settings["enableHaptics"] as? Bool {
            enableHaptics = haptics
        }
        if let notifications = settings["enableNotifications"] as? Bool {
            enableNotifications = notifications
        }
        if let language = settings["selectedLanguage"] as? String {
            selectedLanguage = language
        }
        if let rate = settings["speechRate"] as? Float {
            speechRate = rate
        }
        if let autoAI = settings["autoProcessWithAI"] as? Bool {
            autoProcessWithAI = autoAI
        }
        
        Logger.shared.info("Settings imported")
    }
}
