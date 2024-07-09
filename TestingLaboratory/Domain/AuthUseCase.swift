//
//  LoginUseCase.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/26/24.
//

import Foundation

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
      guard Regex.email.validate(id) else { throw AuthDomainError.invalidEmail }
      guard Regex.password.validate(pw) else { throw AuthDomainError.invalidPassword }
      return try await repository.signUp(id: id, pw: pw)
    }
  
  
    
    func signIn(id: String, pw: String) async throws {
      guard Regex.email.validate(id) else { throw AuthDomainError.invalidEmail }
      guard Regex.password.validate(pw) else { throw AuthDomainError.invalidPassword }
      return try await repository.signIn(id: id, pw: pw)
    }
}
