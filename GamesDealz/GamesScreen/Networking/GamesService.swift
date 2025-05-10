//
//  GamesService.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import Foundation

public enum GamesService {
    case getGames(title: String)
}

extension GamesService: ServiceProtocol {
    public var baseURL: URL? {
        URL(string: "https://www.cheapshark.com/api")
    }
    
    public var path: String? {
        switch self {
        case .getGames(let title):
            return "/1.0/games"
        }
    }
    
    public var httpMethod: HttpMethod {
        switch self {
        case .getGames(let title):
            return .get
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getGames(let title):
            return .none
        }
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .getGames(let title):
            return [.init(name: "title", value: title)]
        }
    }
    
    public var parameters: [String: Any]? {
        .none
    }
    
    public var parametersEncoding: BodyParameterEncoding? {
        .json
    }
}
