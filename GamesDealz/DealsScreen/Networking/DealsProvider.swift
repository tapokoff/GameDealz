//
//  DealsProvider.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import Foundation

public struct DealsProvider: DealsProviderProtocol {
    private let baseUrl: URL?
    @Dependency(\.urlSession) private var urlSession

    public init(baseUrl: URL?) {
        self.baseUrl = baseUrl
    }

    public func getDeals() async throws -> [Deal] {
        try await DealsService.getListOfDeals.perform(baseUrl: baseUrl, urlSession: urlSession)
    }

    public func getDealDetail(id: String) async throws -> [Deal] {
        try await DealsService.getDealDetail(id).perform(baseUrl: baseUrl, urlSession: urlSession)
    }
}
