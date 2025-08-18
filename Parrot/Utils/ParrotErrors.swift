//
//  ParrotErrors.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Foundation

enum RequestError: Error {
    case invalidURL(message: String)
    case serverError(code: Int, message: String)
}
