//
//  DealsReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

@Reducer
public struct DealsReducer {
    @ObservableState
    public struct State: Equatable {
        public var deals: [Deal] = []
    }

    public enum Action: Equatable {
        case onAppear
        case getDeals
        case getDealsResult(TaskResult<[Deal]>)
    }
    
    @Dependency(\.dealsProvider) private var dealsProvider

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.getDeals)
            case .getDeals:
                return .run { send in
                    await send(.getDealsResult(TaskResult {
                        try await dealsProvider.getDeals()
                    }))
                }
            case .getDealsResult(.success(let response)):
                state.deals = response
                return .none
            case .getDealsResult(.failure(let _)):
                // TODO: Present alert
                return .none
            }
        }
    }
}
