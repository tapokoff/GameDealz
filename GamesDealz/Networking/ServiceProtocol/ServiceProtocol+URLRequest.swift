//
//  ServiceProtocol+URLRequest.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

public extension ServiceProtocol {
    func url(baseUrl: URL? = nil) -> URL? {
        guard let url = URL(service: self, baseUrl: baseUrl) else { return nil }
        guard let queryItems else {
            return url
        }
//        return url.appending(queryItems: queryItems)
        
        /// EXPLANATION
        /// This "fix" is neccesery for percentage encoded IDs
        /// The problem is API returning percentage encoded strings with custom encoding `alphanumerics`, so i found this workaround
        ///
        /// Problematic example of Deal ID: 0f%2B4gT2VVUn4UcmFzPxXnuqoXKAOYoJ5mpFZRWNyohc%3D
        var components = URLComponents(string: url.absoluteString)
        components?.percentEncodedQueryItems = []
        for item in queryItems {
            let raw = item.value?.removingPercentEncoding
            let encoded = raw?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            components?.percentEncodedQueryItems?.append(.init(name: item.name, value: encoded ?? ""))
        }
        return components?.url
    }

    func urlRequest(baseUrl: URL? = nil) throws -> URLRequest {
        guard let url = url(baseUrl: baseUrl) else {
            throw ServiceProtocolError.invalidURL(self)
        }

        var request = URLRequest(url: url)

        if parameters != nil, let parametersEncoding {
            switch parametersEncoding {
            case .json:
                request.httpBody = try jsonEncodedParameters()
            case .formUrlEncoded:
                request.setValue(parametersEncoding.rawValue, forHTTPHeaderField: "Content-Type")
                request.httpBody = try formUrlEncodedParameters()
            }
        }

        request.httpMethod = httpMethod.rawValue

        request.timeoutInterval = 20.0

        request.allHTTPHeaderFields = headers

        return request
    }
}

extension ServiceProtocol {
    func jsonEncodedParameters() throws -> Data {
        try JSONSerialization.data(withJSONObject: parameters ?? [:], options: [])
    }

    func formUrlEncodedParameters(using encoding: String.Encoding = .utf8) throws -> Data {
        guard let parameters else { return Data() }
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return components.percentEncodedQuery?.data(using: encoding) ?? .init()
    }
}
