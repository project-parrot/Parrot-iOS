//
//  LoginRepository.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Foundation

protocol LoginRepository {
    /// Attempts to log in with the provided credentials and returns a token pair if successful.
    ///
    /// This function sends a login request to the server using the given credentials.
    /// If the request succeeds and valid tokens are returned, it constructs and returns a `TokenPair`.
    /// Throws an error if the login fails, the endpoint is invalid, or required tokens are missing.
    ///
    /// - Parameter credentials: A dictionary containing login credentials such as email and password.
    /// - Returns: A `TokenPair` containing the access token and refresh token.
    /// - Throws:
    ///   - `RequestError.invalidURL` if the login endpoint is missing or malformed.
    ///   - `RequestError.serverError` if the server responds with an error status code.
    ///   - `AuthError.missingToken` if the response is missing access or refresh tokens.
    ///   - `CancellationError` if the task is cancelled.
    func login(with credentials: [String : Any]) async throws -> TokenPair
}
