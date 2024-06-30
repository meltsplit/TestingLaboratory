//
//  AuthRepositoryStub.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/1/24.
//

import Foundation
@testable import TestingLaboratory

struct AuthRepositoryStub: AuthRepository {
    func signUp(id: String, pw: String) async throws {
        return Void()
    }
    
    func signIn(id: String, pw: String) async throws {
        return Void()
    }
    
    
}
