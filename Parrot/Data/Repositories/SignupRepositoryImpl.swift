//
//  SignupRepositoryImpl.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Factory
import Foundation

final class SignupRepositoryImpl: SignupRepository {
    @Injected(\.remoteDataSource) private var dataSource
    
    func signup(with params: [String : Any]) async throws {
        guard let endpoint = Bundle.main.signupURL else {
            throw RequestError.invalidURL(message: "Failed to retrieve the signup URL. Please check APIEndpoints.plist or configuration.")
        }
        
        try Task.checkCancellation()
        
        let dto = try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: SignupDTO.self
        )
        
        guard 200..<300 ~= dto.code else {
            throw RequestError.serverError(code: dto.code, message: dto.message ?? "")
        }
    }
    
}
