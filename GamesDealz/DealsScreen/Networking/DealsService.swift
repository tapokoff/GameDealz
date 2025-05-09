//
//  DealsService.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

public enum DealsService {
    case getListOfDeals
    case getDealDetail(String)
}

extension DealsService: ServiceProtocol {
    public var baseURL: URL? {
        URL(string: "https://www.cheapshark.com/api")
    }
    
    public var path: String? {
        switch self {
        case .getListOfDeals:
            return "/1.0/deals"
        case .getDealDetail:
            return "/1.0/deals"
        }
    }
    
    public var httpMethod: HttpMethod {
        .get
    }
    
    public var headers: [String: String]? {
        .none
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .getListOfDeals:
            return .none
        case .getDealDetail(let id):
            return [URLQueryItem(name: "id", value: id)]
        }
    }
    
    public var parameters: [String: Any]? {
        .none
    }
    
    public var parametersEncoding: BodyParameterEncoding? {
        .json
    }
}
