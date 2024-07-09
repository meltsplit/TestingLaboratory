//
//  AuthRemoteServiceTests.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/7/24.
//

import XCTest
@testable import TestingLaboratory

final class AuthRemoteServiceTests: XCTestCase {
    
    var sut: AuthRemoteService!
    var stub: Provider<AuthTargetType>!

    override func setUpWithError() throws {
        stub = Provider(stubClosure: authStubFactory)
        sut = DefaultAuthRemoteService(provider: stub)
    }

    override func tearDownWithError() throws {
        sut = nil
        stub = nil
    }
    
    func authStubFactory(_ target: AuthTargetType) -> StubType {
        switch target {
        case .signIn(_):
            return .immediate
        case .signUp(_):
            return .immediate
        }
    }

}

extension AuthRemoteServiceTests {
    
    
    
}
