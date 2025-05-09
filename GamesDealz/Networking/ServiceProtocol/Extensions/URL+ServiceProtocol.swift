//
//  URL+ServiceProtocol.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

extension URL {
    public init?<T: ServiceProtocol>(service: T, baseUrl: URL? = nil) {
        guard let baseUrl = baseUrl ?? service.baseURL else {
            return nil
        }
        guard let servicePath = service.path, !servicePath.isEmpty else {
            self = baseUrl
            return
        }
        self = baseUrl.appendingPathComponent(servicePath)
    }

    func appending(parameters: [String: Any]) -> URL {
        appending(queryItems: parameters.compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") })
    }
}
