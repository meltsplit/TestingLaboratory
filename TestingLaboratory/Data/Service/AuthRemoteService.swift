//
//  AuthRemoteService.swift
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
            guard let error = error as? ProviderError
            else { throw ServiceError.unknown }
            throw error.toService()
        }
    }
    
    func signIn(_ request: SignInRequest) async throws -> SignInResponse {
        do {
            return try await provider.request(
                .signIn(request),
                dto: SignInResponse.self
            )
        } catch {
            guard let error = error as? ProviderError
            else { throw ServiceError.unknown }
            throw error.toService()
        }
        
    }
    
}




