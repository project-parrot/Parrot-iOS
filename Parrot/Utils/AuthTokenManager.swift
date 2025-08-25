//
//  AuthTokenManager.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Foundation

struct AuthTokenManager {
    enum TokenType: String {
        case access
        case refresh
    }
    
    static let shared: AuthTokenManager = .init()
    
    private init() {}
    
    /// Stores a token in the secure storage.
    ///
    /// If a token of the same type already exists, it will be deleted first
    /// before storing the new token.
    ///
    /// - Parameters:
    ///   - token: The token string to store.
    ///   - type: The type of token to store (`access` or `refresh`).
    /// - Returns: A Boolean value indicating whether the token was stored successfully (`true` if successful, `false` otherwise).
    func store(_ token: String, as type: TokenType) async -> Bool {
        await delete(type)
        return await insert(token, as: type)
    }
    
    /// Inserts a token into the secure storage.
    ///
    /// This function adds a new token of the specified type to the Keychain.
    /// It does not delete any existing token of the same type, so calling
    /// `store(_:as:)` is recommended if you want to replace an existing token.
    ///
    /// - Parameters:
    ///   - value: The token string to insert.
    ///   - type: The type of token to insert (`access` or `refresh`).
    /// - Returns: A Boolean value indicating whether the token was successfully inserted (`true` if successful, `false` otherwise).
    private func insert(_ value: String, as type: TokenType) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInteractive).async {
                let saveQuery = baseQuery(for: type)
                saveQuery[kSecValueData] = value.data(using: .utf8)!
                
                continuation.resume(returning: SecItemAdd(saveQuery, nil) == errSecSuccess)
            }
        }
    }
    
    /// Deletes a token of the specified type from the secure storage.
    ///
    /// This function removes the token associated with the given `TokenType`
    /// from the Keychain. If no token exists for the specified type, the operation
    /// has no effect.
    ///
    /// - Parameter type: The type of token to delete (`access` or `refresh`).
    /// - Returns: A Boolean value indicating whether the token was successfully deleted
    ///            (`true` if deletion was successful or token did not exist, `false` otherwise).
    @discardableResult
    func delete(_ type: TokenType) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInteractive).async {
                let status = SecItemDelete(self.baseQuery(for: type))
                            
                if status == errSecSuccess {
                    continuation.resume(returning: true)
                } else {
                    // 디버깅용 로그
                    if let message = SecCopyErrorMessageString(status, nil) as String? {
                        print("🔑 Keychain delete error: \(message)")
                    } else {
                        print("🔑 Keychain delete failed with status: \(status)")
                    }
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    /// Creates a Keychain query dictionary for the specified token type.
    ///
    /// This function generates a dictionary containing the necessary attributes
    /// to perform Keychain operations (add, delete, update) for a token of the
    /// given `TokenType`.
    ///
    /// - Parameter type: The type of token for which to create the query (`access` or `refresh`).
    /// - Returns: An `NSMutableDictionary` containing the Keychain query attributes.
    private func baseQuery(for type: TokenType) -> NSMutableDictionary {
        let serviceName: String = "Parrot"
        
        let query: NSMutableDictionary = [
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue,
            kSecAttrService: serviceName
        ]
        
        return query
    }
}
