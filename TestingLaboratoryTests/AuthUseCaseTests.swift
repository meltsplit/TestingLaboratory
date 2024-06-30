//
//  AuthUseCaseTests.swift
//  TestingLaboratoryTests
//
//  Created by 장석우 on 7/1/24.
//

import XCTest
@testable import TestingLaboratory

final class AuthUseCaseTests: XCTestCase {
  
    var authRepositoryStub: AuthRepositoryStub!
    var sut: AuthUseCase!

    override func setUpWithError() throws {
        authRepositoryStub = .init()
        sut = DefaultAuthUseCase(repository: authRepositoryStub)
    }

    override func tearDownWithError() throws {
        authRepositoryStub = nil
        sut = nil
    }
    
    func test_signIn_유효하지_않은_이메일을_잘_걸러내나요() async throws {
        //given
        let ids = [
            "seokwoo2000.naver.com",
            "seokwoo2000@.com",
            "seok@1.1"
            
        ]
        let pw = "myPassword12!"
        
        for id in ids {
            do {
                //when
                _ = try await sut.signIn(id: id, pw: pw)
                
                XCTAssert(false) // 실행되면 안되는 코드
            } catch let error as AuthError {
                
                //then
                XCTAssertEqual(error, AuthError.invalidEmail)
            } catch  {
                XCTAssertTrue(false) // 실행되면 안되는 코드
            }
        }
        
        
    }

    

}
