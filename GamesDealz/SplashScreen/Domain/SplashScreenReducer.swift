//
//  SplashScreenReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

@Reducer
public struct SplashScreenReducer {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
        case onAppear

        case delegate(Delegate)

        public enum Delegate {
            case openHomeScreen
            case showAlert
        }
    }

    @Dependency(\.storeRepository) private var storeRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        try await storeRepository.refreshStores()
                        await send(.delegate(.openHomeScreen))
                    } catch {
                        await send(.delegate(.showAlert))
                    }
                }
            case .delegate:
                return .none
            }
        }
    }
}
