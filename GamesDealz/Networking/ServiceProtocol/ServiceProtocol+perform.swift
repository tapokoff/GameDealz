//
//  ServiceProtocol+perform.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Combine
import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public extension ServiceProtocol {
    func perform<D: Decodable>(baseUrl: URL?,
                               urlSession: URLSessionProtocol,
                               decoder: JSONDecoder = .init(),
                               handleResponse: ((Data, URLResponse) throws -> D)? = nil) async throws -> D
    {
        let urlRequest = try urlRequest(baseUrl: baseUrl)

        let (data, urlResponse) = try await urlSession.data(for: urlRequest)
        guard let handleResponse else {
            return try Self.handleResponse(data: data, urlResponse: urlResponse, decoder: decoder)
        }
        return try handleResponse(data, urlResponse)
    }

    static func handleResponse<D: Decodable>(data: Data,
                                             urlResponse: URLResponse,
                                             decoder: JSONDecoder,
                                             successCodes: Set<Int> = Set(200 ... 299)) throws -> D
    {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw ServiceProtocolError.unexpectedResponse(urlResponse as? HTTPURLResponse)
        }

        guard successCodes.contains(response.statusCode) else {
            print("<<< \(urlResponse)")
            throw ServiceProtocolError.responseCode(response.statusCode)
        }
        do {
            let string = String(data: data, encoding: .utf8)
            print("<<< \(response) data: \(string ?? "nil")")
            return try decoder.decode(D.self, from: data)
        } catch {
            print(String(data: data, encoding: .utf8) ?? "")
            throw error
        }
    }
}
