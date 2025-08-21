//
//  LoginForm.swift
//  Parrot
//
//  Created by 이정훈 on 8/17/25.
//

import SwiftUI

struct LoginForm: View {
    @Bindable private var loginModel: LoginModel = .init()
    @State private var isShowingSignupForm: Bool = false
    @State private var isShowingLoginErrorAlert: Bool = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                emailField
                
                passwordField
                
                loginButton
                
                SectionSeparator()
                
                signupLink
            }
            .padding()
            .alert("로그인 실패", isPresented: $isShowingLoginErrorAlert) {
                Button("확인") {}
            } message: {
                Text(loginModel.alertMessage ?? "")
            }
            .onDisappear {
                loginModel.task?.cancel()
            }
            
            if loginModel.isLoading {
                SpinningIndicator()
            }
        }
    }
}

fileprivate struct SectionSeparator: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 0.5)
                .layoutPriority(1)
            
            Text("또는")
                .font(.footnote)
                .layoutPriority(2)
            
            Rectangle()
                .frame(height: 0.5)
                .layoutPriority(1)
        }
        .foregroundStyle(.white)
        .padding(.top)
    }
}

// MARK: - Subviews
fileprivate extension LoginForm {
    var backgroundView: some View {
        Image("LoginBackground")
            .resizable()
            .ignoresSafeArea()
    }
    
    var emailField: some View {
        HStack(spacing: 5) {
            Image(systemName: "at")
            
            TextField("이메일을 입력하세요.", text: $loginModel.email)
        }
        .padding()
        .background(.white.opacity(0.4))
        .cornerRadius(30)
    }
    
    var passwordField: some View {
        HStack(spacing: 7) {
            Image(systemName: "lock.fill")
            
            SecureField("비밀번호를 입력하세요.", text: $loginModel.password)
        }
        .padding(.vertical)
        .padding(.leading, 18)
        .padding(.trailing)
        .background(.white.opacity(0.4))
        .cornerRadius(30)
    }
    
    var loginButton: some View {
        Button {
            loginModel.login {
                isLoggedIn = true
            } onFailure: {
                isShowingLoginErrorAlert.toggle()
            }
        } label: {
            Text("로그인")
                .bold()
                .frame(maxWidth: .infinity)
                .padding(10)
        }
        .buttonStyle(.borderedProminent)
        .tint(.black)
        .padding(.top)
    }
    
    var signupLink: some View {
        NavigationLink {
            SignupForm()
        } label: {
            Text("회원가입")
                .underline()
                .foregroundStyle(.white)
        }
        .padding(.top)
    }
}

#Preview {
    NavigationStack {
        LoginForm(isLoggedIn: .constant(false))
    }
}
