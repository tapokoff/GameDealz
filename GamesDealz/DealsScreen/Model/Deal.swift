//
//  Deal.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

public struct Deal: Equatable, Codable {
    public let title: String
    public let id: String
    public let storeId: String
    public let salePrice: String
    public let normalPrice: String
    public let savings: String
    public let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case id = "dealID"
        case storeId = "storeID"
        case salePrice
        case normalPrice
        case savings
        case thumb
    }
}
