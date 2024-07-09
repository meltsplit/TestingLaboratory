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
    var provider: Provider<AuthTargetType>!

    override func setUpWithError() throws {
        provider = Provider()
        sut = DefaultAuthRemoteService(provider: provider)
    }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
    }
    

}

extension AuthRemoteServiceTests {
    
    func test_회원가입시_Provider에서_200을_던질때_response를_잘_반환하는가() async {
        //Given
        let request = SignUpRequest(id: "seokwoo2000@naver.com", pw: "10spsp!!!!!")
        let expect = Data(
"""
{ "statusCode": 200}
"""
    .utf8)
        
        let decodedData = try! JSONDecoder().decode(SignUpResponse.self, from: expect)
        
        let stub: StubType = .networkResponse(200, expect)
        provider.updateStub(stub)
        
        do {
            // When
            let response = try await sut.signUp(request)
            
            //Then
            XCTAssertEqual(response.statusCode, decodedData.statusCode)
        } catch {
            XCTFail()
        }
    }
    
    
    func test_회원가입시_Provider오류를_Service오류로_잘_변환하는가() async {
        let request = SignUpRequest(id: "seokwoo2000@naver.com", pw: "10spsp!!!!!")
        
        let stubs: [StubType] = [
            .networkError(.invalidURL),
            .networkError(.decodedFail),
            .networkError(.encodedFail),
            .networkError(.emptyDataError),
            .networkError(.responseFail)
        ]
        
        let expects: [ServiceError] = [
            .invalidURL,
            .decodedFail,
            .encodedFail,
            .emptyDataError,
            .responseFail
        ]
        
        for (stub, expect) in zip(stubs,expects) {
            
            provider.updateStub(stub)
            
            do {
                let _ = try await sut.signUp(request)
                XCTFail()
            } catch {
                XCTAssertEqual(error as? ServiceError, expect)
            }
            
        }
        
    }
    
    func test_회원가입시_Provider에게_statusCode오류를_Service오류로_잘_변환하는가() async {
        let request = SignUpRequest(id: "seokwoo2000@naver.com", pw: "10spsp!!!!!")
        
        let stubAndExpects: [(StubType, ServiceError)] = [
            (.networkError(.statusError(400)), .badRequest),
            (.networkError(.statusError(401)), .unauthorized),
            
            (.networkError(.statusError(403)), .forbidden),
            (.networkError(.statusError(404)), .notFound),
            (.networkError(.statusError(405)), .methodNotAllowed),
            (.networkError(.statusError(406)), .notAcceptable),
            
            (.networkError(.statusError(408)), .requestTimeOut),
            (.networkError(.statusError(409)), .conflicted),
            
            (.networkError(.statusError(500)), .internalServerError),
            (.networkError(.statusError(501)), .notImplemented),
            (.networkError(.statusError(502)), .badGateway),
            (.networkError(.statusError(503)), .serviceUnavailable),
            
        ]
        
        for (stub, expect) in stubAndExpects {
            
            provider.updateStub(stub)
            
            do {
                let _ = try await sut.signUp(request)
                XCTFail()
            } catch {
                XCTAssertEqual(error as? ServiceError, expect)
            }
            
        }
    }
    
    
}
