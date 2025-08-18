//
//  SignupTests.swift
//  ParrotTests
//
//  Created by 이정훈 on 8/18/25.
//

import Alamofire
import Factory
import Foundation
import Testing
@testable import Parrot

@Test("Expect signup to succeed")
func signup() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    // Given
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    MockURLProtocol.setupMockData(.signupSuccess)
    
    let session = Session(configuration: configuration)
    Container.shared.remoteDataSource.register {
        RemoteDataSource(session: session)
    }
    
    let repository = MockSignupRepositoryImpl()
    Container.shared.signupRepository.register {
        repository
    }
    
    let signupModel = SignupModel()
    signupModel.email = "test@example.com"
    signupModel.password = "123456"
    signupModel.phone = "01012345678"
    signupModel.nickname = "Tester"
    
    // When
    signupModel.signup()
    
    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Then
    let userId = try #require(repository.userId)
    
    #expect(userId == 1)
}
