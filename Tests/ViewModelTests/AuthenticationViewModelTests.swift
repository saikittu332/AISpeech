import XCTest
@testable import AISpeech

final class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthenticationViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Email Validation Tests
    
    func testEmailValidation_ValidEmail() {
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.isEmailValid)
    }
    
    func testEmailValidation_InvalidEmail() {
        viewModel.email = "invalid-email"
        XCTAssertFalse(viewModel.isEmailValid)
    }
    
    func testEmailValidation_EmptyEmail() {
        viewModel.email = ""
        XCTAssertFalse(viewModel.isEmailValid)
    }
    
    // MARK: - Password Validation Tests
    
    func testPasswordValidation_ValidPassword() {
        viewModel.password = "password123"
        XCTAssertTrue(viewModel.isPasswordValid)
    }
    
    func testPasswordValidation_ShortPassword() {
        viewModel.password = "short"
        XCTAssertFalse(viewModel.isPasswordValid)
    }
    
    func testPasswordValidation_EmptyPassword() {
        viewModel.password = ""
        XCTAssertFalse(viewModel.isPasswordValid)
    }
    
    // MARK: - Password Matching Tests
    
    func testPasswordsMatch_Matching() {
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        XCTAssertTrue(viewModel.doPasswordsMatch)
    }
    
    func testPasswordsMatch_NotMatching() {
        viewModel.password = "password123"
        viewModel.confirmPassword = "different"
        XCTAssertFalse(viewModel.doPasswordsMatch)
    }
    
    // MARK: - Login Validation Tests
    
    func testCanLogin_ValidCredentials() {
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        XCTAssertTrue(viewModel.canLogin)
    }
    
    func testCanLogin_InvalidEmail() {
        viewModel.email = "invalid"
        viewModel.password = "password123"
        XCTAssertFalse(viewModel.canLogin)
    }
    
    func testCanLogin_EmptyPassword() {
        viewModel.email = "test@example.com"
        viewModel.password = ""
        XCTAssertFalse(viewModel.canLogin)
    }
    
    // MARK: - Registration Validation Tests
    
    func testCanRegister_ValidData() {
        viewModel.email = "test@example.com"
        viewModel.username = "testuser"
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        XCTAssertTrue(viewModel.canRegister)
    }
    
    func testCanRegister_InvalidEmail() {
        viewModel.email = "invalid"
        viewModel.username = "testuser"
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        XCTAssertFalse(viewModel.canRegister)
    }
    
    func testCanRegister_PasswordMismatch() {
        viewModel.email = "test@example.com"
        viewModel.username = "testuser"
        viewModel.password = "password123"
        viewModel.confirmPassword = "different"
        XCTAssertFalse(viewModel.canRegister)
    }
    
    func testCanRegister_EmptyUsername() {
        viewModel.email = "test@example.com"
        viewModel.username = ""
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        XCTAssertFalse(viewModel.canRegister)
    }
}
