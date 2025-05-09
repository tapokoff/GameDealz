//
//  StoreService.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

public enum StoreService {
    case getStores
}

extension StoreService: ServiceProtocol {
    public var baseURL: URL? {
        URL(string: "https://www.cheapshark.com/api")
    }
    
    public var path: String? {
        "/1.0/stores"
    }
    
    public var httpMethod: HttpMethod {
        .get
    }
    
    public var headers: [String : String]? {
        .none
    }
    
    public var queryItems: [URLQueryItem]? {
        .none
    }
    
    public var parameters: [String : Any]? {
        .none
    }
    
    public var parametersEncoding: BodyParameterEncoding? {
        .json
    }
    
    
}
