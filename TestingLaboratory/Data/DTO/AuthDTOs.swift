//
//  RequestModel.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

// SignUp
struct SignUpRequest: Encodable {
    let id: String
    let pw: String
}

struct SignUpResponse: Decodable {
    let statusCode: Int
}

// SignIn
struct SignInRequest: Encodable {
    let id: String
    let pw: String
}

struct SignInResponse: Decodable {
    let statusCode: Int
}




