import XCTest
@testable import AISpeech

final class StringExtensionTests: XCTestCase {
    
    // MARK: - Email Validation Tests
    
    func testIsValidEmail_Valid() {
        XCTAssertTrue("test@example.com".isValidEmail)
        XCTAssertTrue("user.name@example.co.uk".isValidEmail)
        XCTAssertTrue("test123@test-domain.com".isValidEmail)
    }
    
    func testIsValidEmail_Invalid() {
        XCTAssertFalse("invalid".isValidEmail)
        XCTAssertFalse("@example.com".isValidEmail)
        XCTAssertFalse("test@".isValidEmail)
        XCTAssertFalse("test @example.com".isValidEmail)
    }
    
    // MARK: - Truncation Tests
    
    func testTruncated_ShorterThanLimit() {
        let text = "Short"
        XCTAssertEqual(text.truncated(to: 10), "Short")
    }
    
    func testTruncated_LongerThanLimit() {
        let text = "This is a long text"
        let truncated = text.truncated(to: 10)
        XCTAssertEqual(truncated, "This is a ...")
    }
    
    func testTruncated_WithoutEllipsis() {
        let text = "This is a long text"
        let truncated = text.truncated(to: 10, addEllipsis: false)
        XCTAssertEqual(truncated, "This is a ")
    }
}
