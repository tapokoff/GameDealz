//
//  GamesReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import ComposableArchitecture
import Foundation

private enum DebounceId: Hashable, Sendable {
    case searchDebounce
}

@Reducer
public struct GamesReducer {
    @ObservableState
    public struct State: Equatable {
        public var title: String = ""
        public var games: [Game] = []
        
        public var stores: [Store]
        
        public var isLoading = false
        
        public init(stores: [Store]) {
            self.stores = stores
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case getGames
        case getGamesResult(TaskResult<[Game]>)
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case openDealDetail(DealDetailReducer.State)
            case showAlert
        }
    }
    
    @Dependency(\.gamesProvider) private var gamesProvider
    @Dependency(\.mainQueue) private var mainQueue
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .getGames:
                state.isLoading = true
                state.games = []
                return .run { [state] send in
                    await send(.getGamesResult(TaskResult{
                        try await gamesProvider.getGames(title: state.title)
                    }))
                }
            case .getGamesResult(.success(let response)):
                state.games = response
                state.isLoading = false
                return .none
            case .getGamesResult(.failure):
                state.isLoading = false
                return .none
            case .binding(\.title):
                if state.title.isEmpty {
                    state.isLoading = false
                    return .none
                }
                return .send(.getGames)
                    .debounce(id: DebounceId.searchDebounce, for: .seconds(0.5), scheduler: mainQueue)
                    .cancellable(id: DebounceId.searchDebounce)
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
        ._printChanges()
    }
}
