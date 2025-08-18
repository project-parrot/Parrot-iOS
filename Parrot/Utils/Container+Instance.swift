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
}
