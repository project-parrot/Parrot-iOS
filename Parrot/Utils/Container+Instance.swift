//
//  Container+Instance.swift
//  Parrot
//
//  Created by 이정훈 on 8/18/25.
//

import Factory

extension Container {
    //MARK: - DataSource
    
    var remoteDataSource: Factory<RemoteDataSource> {
        Factory(self) {
            RemoteDataSource()
        }
    }
    
    //MARK: - Repository
    
    var signupRepository: Factory<SignupRepository> {
        Factory(self) {
            SignupRepositoryImpl()
        }
    }
    
    var loginRepository: Factory<LoginRepository> {
        Factory(self) {
            LoginRepositoryImpl()
        }
    }
    
    //MARK: - UseCase
    
    var createAccountUseCase: Factory<CreateAccountUseCase> {
        Factory(self) {
            CreateAccountUseCaseImpl()
        }
    }
    
    var loginUseCase: Factory<LoginUseCase> {
        Factory(self) {
            LoginUseCaseImpl()
        }
    }
}
