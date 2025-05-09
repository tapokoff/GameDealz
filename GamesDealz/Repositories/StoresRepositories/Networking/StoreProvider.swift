//
//  StoreServiceProvider.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation
import ComposableArchitecture

public struct StoreProvider: StoreProviderProtocol {
    private let baseUrl: URL?
    @Dependency(\.urlSession) private var urlSession

    public init(baseUrl: URL?) {
        self.baseUrl = baseUrl
    }

    public func getStores() async throws -> [Store] {
        try await StoreService.getStores.perform(baseUrl: baseUrl, urlSession: urlSession)
    }
}

public struct StoreProviderDependencyKey: DependencyKey {
    public static var liveValue: StoreProviderProtocol = {
        let url = URL(string: "https://www.cheapshark.com/api")
        return StoreProvider(baseUrl: url)
    }()
}

extension DependencyValues {
    var storeProvider: StoreProviderProtocol {
      get { self[StoreProviderDependencyKey.self] }
      set { self[StoreProviderDependencyKey.self] = newValue }
    }
}
