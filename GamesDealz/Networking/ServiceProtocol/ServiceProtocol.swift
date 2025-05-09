//
//  ServiceProtocol.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

public protocol ServiceProtocol {
    var baseURL: URL? { get }

    var path: String? { get }

    var httpMethod: HttpMethod { get }

    var headers: [String: String]? { get }

    var queryItems: [URLQueryItem]? { get }

    var parameters: [String: Any]? { get }

    var parametersEncoding: BodyParameterEncoding? { get }
}
