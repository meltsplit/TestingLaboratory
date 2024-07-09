//
//  Networking.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

enum ProviderError : Error {
    case invalidURL
    case encodedFail
    case decodedFail
}

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case get = "GET"
}

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var body: Encodable? { get }
    var stubData: Data? { get }
}

extension TargetType {
    var stubData: Data? { return nil }
}

extension TargetType {
    var baseURL: String { return "https://naver.com" }
}

protocol ProviderType {
    associatedtype Target: TargetType
    
    func request<Response: Decodable>(
        _ target: Target,
        dto: Response.Type
    ) async throws -> Response
}

enum StubType {
    case never
    case immediate
}


final class Provider<Target: TargetType>: ProviderType {
    
    typealias Target = Target
    typealias StubClosure = (Target) -> StubType
    
    var session: URLSession
    var stubClosure: StubClosure
    
    init(
        session: URLSession = .shared,
        stubClosure: @escaping StubClosure = neverStub
    ) {
        self.session = session
        self.stubClosure = stubClosure
    }
    
    
    func request<Response: Decodable>(
        _ target: Target,
        dto: Response.Type
    ) async throws -> Response {
        
        guard let url = URL(string: target.baseURL + target.path)
        else { throw ProviderError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        
        if let body = target.body {
            guard let data = try? JSONEncoder().encode(body) 
            else { throw ProviderError.encodedFail }
            urlRequest.httpBody = data
        }
        
        let data = try await performRequest(target, urlRequest)
        
        guard let decodedData = try? JSONDecoder().decode(dto, from: data) 
        else { throw ProviderError.decodedFail }
        
        return decodedData
    }
    
    
}

private extension Provider {
    
    func performRequest(
        _ target: Target,
        _ urlRequest: URLRequest
    ) async throws -> Data {
        
        switch stubClosure(target) {
        case .never:
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse // 추후 MockURLProtocol 할 때 
            else { return Data() }
            
            return data
            
        case .immediate:
            return target.stubData ?? Data()
        }
        
    }
    
    static func neverStub(_ target: Target) -> StubType { .never }
    static func stubImmediately(_ target: Target) -> StubType { .immediate }
}


