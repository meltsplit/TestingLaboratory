//
//  AuthEndpoint.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

enum AuthTargetType: TargetType {
    case signIn(_ request: SignInRequest)
    case signUp(_ request: SignUpRequest)
}

extension AuthTargetType {
    
    var path: String {
        switch self {
        case .signIn: "/signIn"
        case .signUp: "/signUp"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .signIn: return .post
        case .signUp: return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .signIn(let request): 
            return request
        case .signUp(let request):
            return request
        }
    }
}
