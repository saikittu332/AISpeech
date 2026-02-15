import Foundation
import Security

/// Keychain manager for secure storage
class KeychainManager {
    static let shared = KeychainManager()
    
    private let serviceName = "com.aispeech.app"
    
    private init() {}
    
    // MARK: - Save
    
    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else {
            Logger.shared.error("Failed to convert value to data")
            return
        }
        
        // Delete any existing item
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            Logger.shared.debug("Successfully saved to keychain: \(key)")
        } else {
            Logger.shared.error("Failed to save to keychain: \(status)")
        }
    }
    
    // MARK: - Load
    
    func load(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            if status != errSecItemNotFound {
                Logger.shared.error("Failed to load from keychain: \(status)")
            }
            return nil
        }
        
        Logger.shared.debug("Successfully loaded from keychain: \(key)")
        return value
    }
    
    // MARK: - Delete
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            Logger.shared.debug("Successfully deleted from keychain: \(key)")
        } else {
            Logger.shared.error("Failed to delete from keychain: \(status)")
        }
    }
    
    // MARK: - Clear All
    
    func clearAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]
        
        SecItemDelete(query as CFDictionary)
        Logger.shared.info("Cleared all keychain items")
    }
}
