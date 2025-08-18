//
//  LoginForm.swift
//  Parrot
//
//  Created by 이정훈 on 8/17/25.
//

import SwiftUI

struct LoginForm: View {
    @State private var isShowingSignupForm: Bool = false
    
    var body: some View {
        Button {
            isShowingSignupForm.toggle()
        } label: {
            Text("회원가입")
        }
        .fullScreenCover(isPresented: $isShowingSignupForm) {
            NavigationStack {
                SignupForm()
            }
        }
    }
}

#Preview {
    LoginForm()
}
