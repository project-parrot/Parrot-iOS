//
//  Bundle+Endpoint.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Foundation

extension Bundle {
    var resource: NSDictionary? {
        guard let file = self.path(forResource: "APIEndpoints", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return nil
        }
        
        return resource
    }
    
    var signupURL: String? {
        guard let resource, let url = resource["Signup_URL"] as? String else {
            return nil
        }
        
        return url
    }
    
    var loginURL: String? {
        guard let resource, let url = resource["Login_URL"] as? String else {
            return nil
        }
        
        return url
    }
}
