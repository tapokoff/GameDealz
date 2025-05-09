//
//  DealsProviderProtocol.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

public protocol DealsProviderProtocol {
    func getDeals() async throws -> [Deal]
    func getDealDetail(id: String) async throws -> [Deal]
}
