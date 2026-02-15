import XCTest
@testable import AISpeech

final class KeychainManagerTests: XCTestCase {
    let keychainManager = KeychainManager.shared
    let testKey = "testKey"
    let testValue = "testValue"
    
    override func setUp() {
        super.setUp()
        // Clean up before each test
        keychainManager.delete(forKey: testKey)
    }
    
    override func tearDown() {
        // Clean up after each test
        keychainManager.delete(forKey: testKey)
        super.tearDown()
    }
    
    // MARK: - Save and Load Tests
    
    func testSaveAndLoad() {
        keychainManager.save(testValue, forKey: testKey)
        let loadedValue = keychainManager.load(forKey: testKey)
        XCTAssertEqual(loadedValue, testValue)
    }
    
    func testLoadNonExistentKey() {
        let loadedValue = keychainManager.load(forKey: "nonExistent")
        XCTAssertNil(loadedValue)
    }
    
    func testOverwriteValue() {
        keychainManager.save(testValue, forKey: testKey)
        keychainManager.save("newValue", forKey: testKey)
        
        let loadedValue = keychainManager.load(forKey: testKey)
        XCTAssertEqual(loadedValue, "newValue")
    }
    
    // MARK: - Delete Tests
    
    func testDelete() {
        keychainManager.save(testValue, forKey: testKey)
        keychainManager.delete(forKey: testKey)
        
        let loadedValue = keychainManager.load(forKey: testKey)
        XCTAssertNil(loadedValue)
    }
    
    func testDeleteNonExistentKey() {
        // Should not crash
        keychainManager.delete(forKey: "nonExistent")
    }
}
