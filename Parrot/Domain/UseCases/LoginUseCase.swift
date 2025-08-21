//
//  LoginUseCase.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Factory
import Foundation

protocol LoginUseCase {
    /// Executes the login process with the given credentials, stores the resulting tokens,
    /// and returns whether both tokens were successfully stored.
    ///
    /// - Parameter credentials: A dictionary containing login credentials such as email and password.
    /// - Returns: `true` if both access and refresh tokens were successfully stored; otherwise, `false`.
    /// - Throws: Any error thrown during login or token storage, including task cancellation.
    func execute(using credentials: [String : Any]) async throws -> Bool
}

final class LoginUseCaseImpl: LoginUseCase {
    @Injected(\.loginRepository) private var repository: LoginRepository
    
    func execute(using credentials: [String : Any]) async throws -> Bool {
        try Task.checkCancellation()
        
        // Perform login request and retrieve access/refresh tokens
        let tokenPair = try await repository.login(with: credentials)
        
        // Store tokens asynchronously
        async let accessTokenTask = AuthTokenManager.shared.store(tokenPair.accessToken, as: .access)
        async let refreshTokenTask = AuthTokenManager.shared.store(tokenPair.refreshToken, as: .refresh)
        
        // Wait for both storage tasks to complete and return true if both succeeded
        return await [accessTokenTask, refreshTokenTask].allSatisfy { $0 == true }
    }
}
