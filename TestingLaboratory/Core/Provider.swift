//
//  Networking.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

enum ProviderError: Error {
    
    case invalidURL
    case encodedFail
    case decodedFail
    case responseFail
    case emptyDataError
    case statusError(Int)
    
    func toService() -> ServiceError {
        switch self {
        case .invalidURL: return .invalidURL
        case .encodedFail: return .encodedFail
        case .decodedFail: return .decodedFail
        case .responseFail: return .responseFail
        case .emptyDataError: return .emptyDataError
        case .statusError(let statusCode): return .init(rawValue: statusCode) ?? .unknown
        }
    }
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
    /// The network returned a response, including status code and data.
    case networkResponse(Int, Data)
    
    /// The network failed to send the request, or failed to retrieve a response (eg a timeout).
    case networkError(ProviderError)
}

final class Provider<Target: TargetType>: ProviderType {
    
    typealias Target = Target
    
    var session: URLSession
    var stubType: StubType
    
    init(
        session: URLSession = .shared,
        stubType: StubType = .never
    ) {
        self.session = session
        self.stubType = stubType
    }
    
    func updateStub(_ stub: StubType) {
        self.stubType = stub
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
        
        switch stubType {
            
        case .never:
            let (data, response) = try await session.data(for: urlRequest) //TODO: error 핸들링
            
            guard let response = response as? HTTPURLResponse // 추후 MockURLProtocol 할 때
            else { throw ProviderError.responseFail }
            
            guard (200...399).contains(response.statusCode)
            else { throw ProviderError.statusError(response.statusCode) }
            
            guard let decodedData = try? JSONDecoder().decode(dto, from: data)
            else { throw ProviderError.decodedFail }
            
            return decodedData
            
        case .networkResponse(let statusCode, let data):
            
            guard (200...399).contains(statusCode)
            else { throw ProviderError.statusError(statusCode) }
            guard let decodedData = try? JSONDecoder().decode(dto, from: data)
            else { throw ProviderError.decodedFail }
            
            return decodedData
            
        case .networkError(let error):
            throw error
        }
        
    }
    
    
}

private extension Provider {

    static func neverStub(_ target: Target) -> StubType { .never }
}


