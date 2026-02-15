import XCTest
@testable import AISpeech

final class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Default Values Tests
    
    func testDefaultValues() {
        XCTAssertEqual(viewModel.fontSize, 16.0)
        XCTAssertEqual(viewModel.selectedLanguage, Constants.Speech.defaultLanguage)
        XCTAssertEqual(viewModel.speechRate, Constants.Speech.defaultSpeechRate)
    }
    
    // MARK: - Settings Persistence Tests
    
    func testSettingsPersistence_DarkMode() {
        viewModel.isDarkMode = true
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "isDarkMode"))
        
        viewModel.isDarkMode = false
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "isDarkMode"))
    }
    
    func testSettingsPersistence_FontSize() {
        viewModel.fontSize = 20.0
        XCTAssertEqual(UserDefaults.standard.double(forKey: "fontSize"), 20.0)
    }
    
    func testSettingsPersistence_Language() {
        viewModel.selectedLanguage = "es-ES"
        XCTAssertEqual(UserDefaults.standard.string(forKey: "selectedLanguage"), "es-ES")
    }
    
    // MARK: - Reset to Defaults Tests
    
    func testResetToDefaults() {
        // Change all settings
        viewModel.isDarkMode = true
        viewModel.fontSize = 20.0
        viewModel.enableHaptics = false
        viewModel.enableNotifications = false
        viewModel.selectedLanguage = "es-ES"
        
        // Reset
        viewModel.resetToDefaults()
        
        // Verify defaults
        XCTAssertFalse(viewModel.isDarkMode)
        XCTAssertEqual(viewModel.fontSize, 16.0)
        XCTAssertTrue(viewModel.enableHaptics)
        XCTAssertTrue(viewModel.enableNotifications)
        XCTAssertEqual(viewModel.selectedLanguage, Constants.Speech.defaultLanguage)
    }
    
    // MARK: - Export/Import Tests
    
    func testExportSettings() {
        viewModel.isDarkMode = true
        viewModel.fontSize = 18.0
        
        let exported = viewModel.exportSettings()
        
        XCTAssertEqual(exported["isDarkMode"] as? Bool, true)
        XCTAssertEqual(exported["fontSize"] as? Double, 18.0)
    }
    
    func testImportSettings() {
        let settings: [String: Any] = [
            "isDarkMode": true,
            "fontSize": 20.0,
            "enableHaptics": false,
            "selectedLanguage": "fr-FR"
        ]
        
        viewModel.importSettings(settings)
        
        XCTAssertTrue(viewModel.isDarkMode)
        XCTAssertEqual(viewModel.fontSize, 20.0)
        XCTAssertFalse(viewModel.enableHaptics)
        XCTAssertEqual(viewModel.selectedLanguage, "fr-FR")
    }
}
