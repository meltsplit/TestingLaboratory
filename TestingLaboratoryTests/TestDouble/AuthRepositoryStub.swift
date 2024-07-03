//
//  AuthRepositoryStub.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/1/24.
//

import Foundation
@testable import TestingLaboratory

struct AuthRepositoryStub {
    
    private var unExpectedErrorOccured: Bool = false
    
    mutating func setUnExpectedError(_ isOccured: Bool) {
        self.unExpectedErrorOccured = isOccured
    }
    
}

extension AuthRepositoryStub: AuthRepository {
    
    func signUp(id: String, pw: String) async throws {
        guard !unExpectedErrorOccured else { throw NSError() }
        return Void()
    }
    
    func signIn(id: String, pw: String) async throws {
        guard !unExpectedErrorOccured else { throw NSError() }
        return Void()
    }
    
}
