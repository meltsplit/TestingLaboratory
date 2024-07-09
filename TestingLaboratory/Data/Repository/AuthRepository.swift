//
//  AuthRepository.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/26/24.
//

import Foundation

protocol AuthRepository {
  func signUp(id: String, pw: String) async throws
  func signIn(id: String, pw: String) async throws
}

struct DefaultAuthRepository: AuthRepository {
  
  let remoteService: AuthRemoteService
  
  init(remoteService: AuthRemoteService) {
    self.remoteService = remoteService
  }
  
  func signUp(id: String, pw: String) async throws {
    let response = try await remoteService.signUp(.init(id: id, pw: pw))
    
    guard response.statusCode != 4001 else { throw AuthDataError.alreadyExistEmail }
    guard (200..<400).contains(response.statusCode) else { throw AuthDataError.unknown }
  }
  
  func signIn(id: String, pw: String) async throws {
    let response = try await remoteService.signIn(.init(id: id, pw: pw))
    
    guard response.statusCode != 401 else { throw AuthDataError.notAuthorized }
    guard response.statusCode != 404 else { throw AuthDataError.userNotFound }
    guard (200..<400).contains(response.statusCode) else { throw AuthDataError.unknown }
  }
}

