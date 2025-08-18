//
//  SignupRepository.swift
//  Parrot
//
//  Created by 이정훈 on 8/17/25.
//

import Foundation

protocol SignupRepository {
    func signup(with params: [String: Any]) async throws
}
