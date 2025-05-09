//
//  StoreServiceProviderProtocol.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

public protocol StoreProviderProtocol {
    func getStores() async throws -> [Store]
}
