//
//  RemoteAuthService.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

struct AuthNetworking: Networking {
    typealias EndPoint = AuthEndpoint
}

protocol RemoteAuthService {
    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse
    func signIn(_ request: SignInRequest) async throws -> SignInResponse
}

class DefaultRemoteAuthService: RemoteAuthService {
    
    let networking: AuthNetworking
    
    init(networking: AuthNetworking) {
        self.networking = networking
    }
    
    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse {
        try await networking.request(
            with: .signUp(request),
            dto: SignUpResponse.self
        )
    }
    
    func signIn(_ request: SignInRequest) async throws -> SignInResponse {
        try await networking.request(
            with: .signIn(request),
            dto: SignInResponse.self
        )
    }
    
}




