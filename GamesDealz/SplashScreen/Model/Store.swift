//
//  Store.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

public struct Store: Equatable, Codable {
    public let id: String
    public let name: String
    public let images: StoreImages
    
    enum CodingKeys: String, CodingKey {
        case id = "storeID"
        case name = "storeName"
        case images
    }
}

public struct StoreImages: Equatable, Codable {
    private let logoPath: String
    private let iconPath: String
    
    enum CodingKeys: String, CodingKey {
        case logoPath = "logo"
        case iconPath = "icon"
    }
    
    public var logoImage: String {
        "https://www.cheapshark.com" + logoPath
    }
    
    public var iconImage: String {
        "https://www.cheapshark.com" + iconPath
    }
}
