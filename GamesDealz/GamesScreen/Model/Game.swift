//
//  Game.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

public struct Game: Equatable, Codable {
    public let id: String
    public let cheapestPrice: String
    public let cheapestDealId: String
    public let name: String
    public let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case id = "gameID"
        case cheapestPrice = "cheapest"
        case cheapestDealId = "cheapestDealID"
        case name = "external"
        case thumb
    }
}
