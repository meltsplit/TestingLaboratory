//
//  AuthDataError.swift
//  TestingLaboratory
//
//  Created by 장석우 on 7/9/24.
//

import Foundation

enum AuthDataError: Error {
    case userNotFound
    case notAuthorized
    case alreadyExistEmail
    case unknown
    
}
