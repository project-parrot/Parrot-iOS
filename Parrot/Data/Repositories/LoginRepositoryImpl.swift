//
//  LoginRepositoryImpl.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Factory
import Foundation

final class LoginRepositoryImpl: LoginRepository {
    @Injected(\.remoteDataSource) private var dataSource
    
    func login(with credentials: [String : Any]) async throws -> TokenPair {
        guard let endpoint = Bundle.main.loginURL else {
            throw RequestError.invalidURL(message: "Missing or invalid login URL in Bundle configuration.")
        }
        
        try Task.checkCancellation()
        
        let dto = try await dataSource.request(
            endpoint,
            method: .post,
            parameters: credentials,
            decoding: LoginDTO.self
        )
        
        guard 200..<300 ~= dto.code else {
            throw RequestError.serverError(code: dto.code, message: dto.message ?? "")
        }
        
        guard let accessToken = dto.data?.accessToken,
              let refreshToken = dto.data?.refreshToken else {
            throw AuthError.missingToken
        }
        
        return TokenPair(accessToken: accessToken, refreshToken: refreshToken)
    }
}
