//
//  GamesProvider.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import ComposableArchitecture
import Foundation

public struct GamesProvider: GamesProviderProtocol {
    private let baseUrl: URL?

    @Dependency(\.urlSession) private var urlSession

    public init(baseUrl: URL?) {
        self.baseUrl = baseUrl
    }

    public func getGames(title: String) async throws -> [Game] {
        try await GamesService.getGames(title: title).perform(baseUrl: baseUrl, urlSession: urlSession)
    }
}

public struct GamesProviderDependencyKey: DependencyKey {
    public static var liveValue: GamesProviderProtocol = {
        let url = URL(string: "https://www.cheapshark.com/api")
        return GamesProvider(baseUrl: url)
    }()
}

extension DependencyValues {
    var gamesProvider: GamesProviderProtocol {
        get { self[GamesProviderDependencyKey.self] }
        set { self[GamesProviderDependencyKey.self] = newValue }
    }
}
