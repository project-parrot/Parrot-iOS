//
//  RemoteDataSource.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Alamofire
import Foundation

struct RemoteDataSource {
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    @discardableResult
    func request<T>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        decoding type: T.Type
    ) async throws -> T where T: Decodable {
        return try await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .serializingDecodable(type)
        .value
    }
}
