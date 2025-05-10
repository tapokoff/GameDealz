//
//  GamesProviderProtocol.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import ComposableArchitecture
import Foundation

public protocol GamesProviderProtocol {
    func getGames(title: String) async throws -> [Game]
}
