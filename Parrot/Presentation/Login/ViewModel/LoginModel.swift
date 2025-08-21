//
//  LoginModel.swift
//  Parrot
//
//  Created by 이정훈 on 8/20/25.
//

import Factory
import Foundation

@Observable
final class LoginModel {
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    
    @ObservationIgnored
    @Injected(\.loginUseCase) private var useCase
    
    @ObservationIgnored
    var alertMessage: String?
    
    @ObservationIgnored
    var task: Task<Void, Never>?
    
    func login(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        isLoading = true
        
        task = Task {
            defer { isLoading = false }
            
            do {
                let loginResult = try await useCase.execute(using: createParameters())
                
                if loginResult {
                    onSuccess()
                } else {
                    onFailure()
                }
            } catch {
                print(error)
                alertMessage = error.localizedDescription
                onFailure()
            }
        }
    }
    
    private func createParameters() -> [String : Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}
