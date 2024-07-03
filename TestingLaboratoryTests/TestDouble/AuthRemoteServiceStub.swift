//
//  File.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/3/24.
//

import Foundation

@testable import TestingLaboratory

class AuthRemoteServiceStub: RemoteAuthService {
    
    var signUpResponse: SignUpResponse?
    var signUpError: Error?
    
    
    var signInResponse: SignInResponse?
    var signInError: Error?
    
    
    func signUp(_ request: TestingLaboratory.SignUpRequest) async throws -> TestingLaboratory.SignUpResponse {
        guard signUpError == nil else { throw signUpError! }
        guard let response = signUpResponse else { fatalError("개발자가 response를 설정하지 않았습니다.")}
        return response
    }
    
    func signIn(_ request: TestingLaboratory.SignInRequest) async throws -> TestingLaboratory.SignInResponse {
        guard signInError == nil else { throw signInError! }
        guard let response = signInResponse else { fatalError("개발자가 response를 설정하지 않았습니다.")}
        return response
    }
    
}
