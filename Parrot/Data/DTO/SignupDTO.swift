//
//  SignupDTO.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Foundation

// MARK: - SignupDTO
struct SignupDTO: Decodable {
    let success: Bool
    let code: Int
    let message: String?
    let data: SignupResponseData
}

// MARK: - SignupResponseData
struct SignupResponseData: Decodable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
