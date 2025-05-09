//
//  DealDetail.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

public struct DealDetail: Equatable, Codable {
    public let gameInfo: DealGameInfo
    public let cheaperStores: [OtherDeals]
}

public struct DealGameInfo: Equatable, Codable {
    public let storeId: String
    public let name: String
    public let salePrice: String
    public let steamRatingText: String
    public let steamRatingPercent: String
    public let metacriticScore: String
    public let metacriticLink: String?
    public let publisher: String
    public let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case storeId = "storeID"
        case name
        case salePrice
        case steamRatingText
        case steamRatingPercent
        case metacriticScore
        case metacriticLink
        case publisher
        case thumb
    }
}

public struct OtherDeals: Equatable, Codable {
    public let dealId: String
    public let storeId: String
    public let salePrice: String
    public let retailPrice: String
}
