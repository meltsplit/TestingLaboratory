//
//  RemoteAuthService.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

protocol AuthRemoteService {
    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse
    func signIn(_ request: SignInRequest) async throws -> SignInResponse
}

class DefaultAuthRemoteService: AuthRemoteService {
    
    private let provider: Provider<AuthTargetType>
    
    init(provider: Provider<AuthTargetType>) {
        self.provider = provider
    }
    
    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse {
        do {
            return try await provider.request(
                .signUp(request),
                dto: SignUpResponse.self
            )
        } catch {
            if error is AuthError { throw AuthError.notAuthorized }
            throw AuthError.unknown
        }
        
    }
    
    func signIn(_ request: SignInRequest) async throws -> SignInResponse {
        try await provider.request(
            .signIn(request),
            dto: SignInResponse.self
        )
    }
    
}




