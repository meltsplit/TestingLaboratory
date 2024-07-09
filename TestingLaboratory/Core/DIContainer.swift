//
//  DIContainer.swift
//  TestingLaboratory
//
//  Created by 장석우 on 7/8/24.
//

import Foundation

final class DIContainer {
    static var shared = DIContainer()
    private init() {}
}

extension DIContainer {
    
    func makeAuthUseCase() -> AuthUseCase {
        
        let pv = Provider<AuthTargetType>()
        let rs = DefaultAuthRemoteService(provider: pv)
        let rp = DefaultAuthRepository(remoteService: rs)
        let uc = DefaultAuthUseCase(repository: rp)
        
        return uc
    }
    
}
