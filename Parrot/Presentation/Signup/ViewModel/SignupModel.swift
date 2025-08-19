//
//  SignupInfo.swift
//  Parrot
//
//  Created by 이정훈 on 8/17/25.
//

import Factory
import Foundation

@Observable
final class SignupModel {
    @ObservationIgnored
    @Injected(\.signupRepository) private var repository
    
    @ObservationIgnored
    var task: Task<Void, Never>?
    
    //MARK: Email Properties
    var email: String = "" {
        didSet {
            guard oldValue != email else { return }
            
            validate(email: email)
        }
    }
    
    var isShowingEmailFootnote: Bool = false
    
    //MARK: - Password Properties
    var password: String = "" {
        didSet {
            guard oldValue != password else { return }
            
            validate(password: password)
        }
    }
    
    var isShowingPasswordFootnote: Bool = false
    
    //MARK: - Password Confirmation Properties
    var passwordConfirmation: String = "" {
        didSet {
            guard oldValue != passwordConfirmation else { return }
            
            validate(passwordConfirmation: passwordConfirmation)
        }
    }
    
    var isShowingPasswordConfirmationFootnote: Bool = false
    
    //MARK: - Phone Properties
    var phone: String = "" {
        didSet {
            guard oldValue != phone else { return }
            
            validate(phone: phone)
        }
    }
    
    var isShowingPhoneFootnote: Bool = false
    
    //MARK: - Nickname Properties
    var nickname: String = "" {
        didSet {
            guard oldValue != nickname else { return }
            
            validate(nickname: nickname)
        }
    }
    
    var isShowingNicknameFootnote: Bool = false
    
    //MARK: - Sign Up Properties
    
    var signupErrorMessage: String?
    
    var isLoading: Bool = false
    
    //MARK: - Signup Method
    
    func signup(onSuccess: @escaping () -> Void) {
        isLoading = true
        
        task = Task {
            defer { isLoading = false }
            
            do {
                let params = makeParameters()
                try await repository.signup(with: params)
                onSuccess()
            } catch {
                print(error)
                signupErrorMessage = extractErrorMessage(from: error)
            }
        }
    }
    
    private func makeParameters() -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "phone": phone,
            "nickname": nickname
        ]
    }
    
    private func extractErrorMessage(from error: Error) -> String? {
        if let requestError = error as? RequestError {
            switch requestError {
            case .serverError(_, let message):
                return message
            case .invalidURL(let message):
                return message
            }
        }
        
        return error.localizedDescription
    }
    
}

extension SignupModel {
    //MARK: - Validate Email Address
    
    func validate(email: String) {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        isShowingEmailFootnote = !validateInput(email, regex: regex)
    }
    
    //MARK: - Validate Password
    
    func validate(password: String) {
        let regex = #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$"#
        
        isShowingPasswordFootnote = !validateInput(password, regex: regex)
    }
    
    //MARK: - Validate Password Confirmation
    
    func validate(passwordConfirmation: String) {
        isShowingPasswordConfirmationFootnote = !(password == passwordConfirmation)
    }
    
    //MARK: - Validate Phone Number
    
    func validate(phone: String) {
        let regex = #"^01[0-1, 7][0-9]{7,8}$"#
        
        isShowingPhoneFootnote = !validateInput(phone, regex: regex)
    }
    
    //MARK: - Validate Nickname
    
    func validate(nickname: String) {
        let regex = #"^.{2,30}$"#
        
        isShowingNicknameFootnote = !validateInput(nickname, regex: regex)
    }
    
    private func validateInput(_ input: String, regex: String) -> Bool {
        guard !input.isEmpty else { return true }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
    
}

extension SignupModel {
    var isSignupAvailable: Bool {
        return !email.isEmpty &&
               !password.isEmpty &&
               !passwordConfirmation.isEmpty &&
               !phone.isEmpty &&
               !nickname.isEmpty &&
               !isShowingEmailFootnote &&
               !isShowingPasswordFootnote &&
               !isShowingPasswordConfirmationFootnote &&
               !isShowingPhoneFootnote &&
               !isShowingNicknameFootnote
    }
    
}
