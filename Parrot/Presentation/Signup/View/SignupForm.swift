//
//  SignupForm.swift
//  Parrot
//
//  Created by 이정훈 on 8/17/25.
//

import SwiftUI

struct SignupForm: View {
    @State private var signupModel: SignupModel = .init()
    
    var body: some View {
        Form {
            Section {
                TextField(text: $signupModel.email) {
                    Text("이메일")
                }
            } footer: {
                Text(signupModel.isShowingEmailFootnote ? "유효한 이메일 주소를 입력해주세요." : " ")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Section {
                SecureField(text: $signupModel.password) {
                    Text("비밀번호")
                }
                .textContentType(.newPassword)
            } footer: {
                Text(signupModel.isShowingPasswordFootnote ? "5~20자의 영문과 숫자를 조합해 주세요." : " ")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Section {
                SecureField(text: $signupModel.passwordConfirmation) {
                    Text("비밀번호 확인")
                }
                .textContentType(.newPassword)
            } footer: {
                Text(signupModel.isShowingPasswordConfirmationFootnote ? "비밀번호가 일치하지 않아요." : " ")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Section {
                TextField(text: $signupModel.phone) {
                    Text("전화번호")
                }
            } footer: {
                Text(signupModel.isShowingPhoneFootnote ? "숫자와 하이픈(-)을 포함한 올바른 형식의 전화번호를 입력해 주세요." : " ")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Section {
                TextField(text: $signupModel.nickname) {
                    Text("닉네임")
                }
            } footer: {
                Text(signupModel.isShowingNicknameFootnote ? "닉네임은 최소 2자, 최대 30자까지 입력할 수 있어요." : " ")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    signupModel.signup()
                } label: {
                    Text("완료")
                }
            }
        }
        .onDisappear {
            signupModel.task?.cancel()
        }
    }
}

#Preview {
    NavigationStack {
        SignupForm()
    }
}
