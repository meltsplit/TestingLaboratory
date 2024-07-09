//
//  AuthRepositoryTests.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/3/24.
//

import XCTest
@testable import TestingLaboratory

final class AuthRepositoryTests: XCTestCase {
    
    var sut: AuthRepository!
    var stub: AuthRemoteServiceStub!

    override func setUpWithError() throws {
        stub = .init()
        sut = DefaultAuthRepository(remoteService: stub)
    }

    override func tearDownWithError() throws {
        stub = nil
        sut = nil
    }
    
}

//MARK: - SignUp
extension AuthRepositoryTests {
    func testSignUp_Success() async throws {
        // given
        stub.signUpResponse = .init(statusCode: 200)
        
        // when
        try await sut.signUp(id: "test@example.com", pw: "Password123!")
        
        // then
        // No assertion needed for success case
    }
    
    func testSignUp_AlreadyExistEmail() async throws {
        // given
        stub.signUpResponse = .init(statusCode: 4001)
        
        // when
        do {
            try await sut.signUp(id: "existing@example.com", pw: "Password123!")
            XCTFail("Expected error AuthError.alreadyExistEmail not thrown")
        } catch {
            // then
            XCTAssertTrue(error is AuthDataError)
            XCTAssertEqual(error as? AuthDataError, AuthDataError.alreadyExistEmail)
        }
    }
    
    func testSignUp_OtherErrors() async throws {
        // given
        stub.signUpError = NSError(domain: "MockError", code: 500, userInfo: nil)
        
        // when
        do {
            try await sut.signUp(id: "test@example.com", pw: "Password123!")
            XCTFail("Expected error AuthError.unknown not thrown")
        } catch {
            // then
        }
    }
}

//MARK: - SignIn
extension AuthRepositoryTests {
        
        func testSignIn_Success() async throws {
            // given
            stub.signInResponse = .init(statusCode: 200)
            
            // when
            try await sut.signIn(id: "test@example.com", pw: "Password123!")
            
            // then
            // No assertion needed for success case
        }
        
        func testSignIn_UserNotFound() async throws {
            // given
            stub.signInResponse = .init(statusCode: 404)
            
            // when
            do {
                try await sut.signIn(id: "nonexisting@example.com", pw: "Password123!")
                XCTFail("Expected error AuthError.userNotFound not thrown")
            } catch {
                // then
                XCTAssertTrue(error is AuthDataError)
                XCTAssertEqual(error as? AuthDataError, AuthDataError.userNotFound)
            }
        }
        
        func testSignIn_NotAuthorized() async throws {
            // given
            stub.signInResponse = .init(statusCode: 401)
            
            // when
            do {
                try await sut.signIn(id: "test@example.com", pw: "WrongPassword123!")
                XCTFail("Expected error AuthError.notAuthorized not thrown")
            } catch {
                // then
                XCTAssertTrue(error is AuthDataError)
                XCTAssertEqual(error as? AuthDataError, AuthDataError.notAuthorized)
            }
        }
        
        func testSignIn_OtherErrors() async throws {
            // given
            stub.signInError = NSError(domain: "MockError", code: 500, userInfo: nil)
            
            // when
            do {
                try await sut.signIn(id: "test@example.com", pw: "Password123!")
                XCTFail("Expected error AuthError.unknown not thrown")
            } catch {
                // then
            }
        }
}
