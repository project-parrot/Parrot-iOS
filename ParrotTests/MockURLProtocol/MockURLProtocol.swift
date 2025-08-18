//
//  MockURLProtocol.swift
//  ParrotTests
//
//  Created by 이정훈 on 8/18/25.
//

import Alamofire
import Foundation

final class MockURLProtocol: URLProtocol {
    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()
    var activeTask: URLSessionTask?
    private static var mockFileName: String!
    
    //파라미터로 전달된 Request를 처리할 수 있는지 여부
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    //표준 URLRequst를 반환
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    //캐싱 사용하지 않음
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        guard let mockData = createMockData(), let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: mockData)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
    
    func createMockData() -> Data? {
        let testBundle = Bundle(for: MockURLProtocol.self)

        guard let fileURL = testBundle.url(forResource: Self.mockFileName, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileURL)
    }
}

extension MockURLProtocol {
    enum MockDataType: String {
        case signupSuccess
    }
    
    static func setupMockData(_ type: MockDataType) {
        mockFileName = type.rawValue
    }
}
