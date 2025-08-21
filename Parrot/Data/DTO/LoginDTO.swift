//
//  LoginDTO.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Foundation

// MARK: - LoginDTO
struct LoginDTO: Decodable {
    let success: Bool
    let code: Int
    let message: String?
    let data: LoginResponseData?
}

// MARK: - DataClass
struct LoginResponseData: Decodable {
    let accessToken, refreshToken: String
}
