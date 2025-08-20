//
//  CreateUserAccountUseCase.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Factory
import Foundation

protocol CreateAccountUseCase {
    func execute(using signupData: [String: Any]) async throws
}

final class CreateAccountUseCaseImpl: CreateAccountUseCase {
    @Injected(\.signupRepository) private var repository: SignupRepository
    
    func execute(using signupData: [String : Any]) async throws {
        return try await repository.signup(with: signupData)
    }
}
