//
//  LoginUseCase.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/26/24.
//

import Foundation

enum AuthError: Error {
  case alreadyExistEmail
  case invalidEmail
  case invalidPassword
  case userNotFound
  case notAuthorized
  case unknown
}

protocol AuthUseCase {
    func signUp(id: String, pw: String) async throws
    func signIn(id: String, pw: String) async throws
}

struct DefaultAuthUseCase: AuthUseCase {

    let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp(id: String, pw: String) async throws {
      guard Regex.email.validate(id) else { throw AuthError.invalidEmail }
      guard Regex.password.validate(pw) else { throw AuthError.invalidPassword }
      return try await repository.signUp(id: id, pw: pw)
    }
  
  
    
    func signIn(id: String, pw: String) async throws {
      guard Regex.email.validate(id) else { throw AuthError.invalidEmail }
      guard Regex.password.validate(pw) else { throw AuthError.invalidPassword }
      return try await repository.signIn(id: id, pw: pw)
    }
}
