//
//  Networking.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/27/24.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case get = "GET"
}

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var body: Encodable? { get }
}

extension EndPointType {
    var baseURL: String { return "https://naver.com" }
}

protocol Networking {
    associatedtype EndPoint: EndPointType
    
    func request<Response: Decodable>(
        with endPoint: EndPoint,
        dto: Response.Type
    ) async throws -> Response
}

extension Networking {
    
    func request<Response: Decodable>(
        with endPoint: EndPoint,
        dto: Response.Type
    ) async throws -> Response {
      
      guard let url = URL(string: endPoint.baseURL + endPoint.path) else {
          throw NSError()
      }
      
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = endPoint.method.rawValue
      
      if let body = endPoint.body,
         let data = try? JSONEncoder().encode(body) {
        urlRequest.httpBody = data
      }
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      
      guard let response = response as? HTTPURLResponse else {
          throw NSError()
      }
      
      return try JSONDecoder().decode(dto, from: data)
    }
    
}
