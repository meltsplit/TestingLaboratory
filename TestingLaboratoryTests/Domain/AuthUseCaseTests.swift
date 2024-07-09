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
    
}


extension AuthUseCaseTests {
    
    func test_signIn_유효하지_않은_이메일을_잘_걸러내나요() async throws {
        //given
        let invalidEmails = [
            "user@domain",
            "user@domain..com",
            "user@domain_com",
            "userdomain.com",
            "user@domaincom",
            "@domain.com",
            "user@.com",
            "user@domain.",
            "user@domain..com",
            "user@domain.c"
        ]
        
        let pw = "myPassword12!"
        
        for id in invalidEmails {
            do {
                //when
                _ = try await sut.signIn(id: id, pw: pw)
                
                XCTFail("\(id) 이메일 유효하지 않은데 성공으로 뜬 오류")
            } catch AuthDomainError.invalidEmail {
                //여기에 들어갈 적합한 코드
                XCTAssertTrue(true)
            } catch  {
                XCTFail("유효하지 않은 이메일에 AuthError가 아닌 다른 에러가 방출된 경우")
            }
        }
        
        
    }
    
    func test_signIn_유효하지_않은_비밀번호를_잘_걸러내나요() async throws {
        //given
        let id = "seokwoo2000@naver.com"
        let invalidPasswords = [
            "password",
            "12345678",
            "!@#$%^&*()_+",
            "abcdefghi",
            "Password",
            "abcdefg123",
            "!@#$%^&*()_",
            "12345678a",
            "password123",
            "!@#$%^&*()_password"
        ]
        
        for pw in invalidPasswords {
            do {
                //when
                _ = try await sut.signIn(id: id, pw: pw)
                
                XCTFail("비밀번호 유효하지 않은데 성공으로 뜬 오류")
            } catch AuthDomainError.invalidPassword {
                XCTAssertTrue(true)
            } catch  {
                XCTFail("유효하지 않은 이메일에 AuthError가 아닌 다른 에러가 방출된 경우")
            }
        }
        
    }
    
    func test_signIn_레포지토리에서_발생한_오류를_잘_잡아내나요() async {
        
        //Given
        authRepositoryStub.setUnExpectedError(true)
        sut = DefaultAuthUseCase(repository: authRepositoryStub)
        let id = "seokwoo2000@naver.com"
        let pw = "abcABC123!!"
        
        //When
        do {
            _ = try await sut.signIn(id: id, pw: pw)
            XCTFail("레포지토리에서 에러를 발생시켰는데 유즈케이스가 에러를 받지 못함")
        } catch  _ as AuthDomainError {
            XCTFail("레포지토리에서 Auth 외의 에러를 발생시켰는데 AuthError로 분류됨")
        } catch {
            //Then
            XCTAssertTrue(true)
        }
        
        
    }
    
    

}
