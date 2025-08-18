//
//  MockSignupRepositoryImpl.swift
//  ParrotTests
//
//  Created by 이정훈 on 8/18/25.
//

import Alamofire
import Factory
import Foundation
@testable import Parrot

final class MockSignupRepositoryImpl: SignupRepository {
    @Injected(\.remoteDataSource) private var dataSource
    private(set) var userId: Int?
    
    func signup(with params: [String : Any]) async throws {
        guard let endpoint = Bundle.main.signupURL else {
            throw RequestError.invalidURL(
                message: "Failed to retrieve the signup URL. Please check APIEndpoints.plist or configuration."
            )
        }
        
        try Task.checkCancellation()
        
        let dto = try await dataSource.request(
            endpoint,
            method: .post,
            parameters: params,
            decoding: SignupDTO.self
        )
        
        userId = dto.data?.userID
    }
}
