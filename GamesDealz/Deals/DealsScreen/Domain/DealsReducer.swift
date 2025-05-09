//
//  DealsReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

private enum DebounceId: Hashable, Sendable {
    case searchDebounce
}

@Reducer
public struct DealsReducer {
    @ObservableState
    public struct State: Equatable {
        public var deals: [Deal] = []
        public var pageNumber = 0

        public var title: String = ""
    }

    public enum Action: Equatable, BindableAction {
        case onAppear
        
        case getMoreDeals
        case getMoreDealsResult(TaskResult<[Deal]>)
        
        case getDeals
        case getDealsResult(TaskResult<[Deal]>)

        case binding(BindingAction<State>)
    }

    @Dependency(\.dealsProvider) private var dealsProvider
    @Dependency(\.mainQueue) private var mainQueue

    public init() {}

    public var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.getDeals)
            case .getDeals:
                state.pageNumber = 0
                return .run { [state] send in
                    await send(.getDealsResult(TaskResult {
                        try await dealsProvider.getDeals(page: "\(state.pageNumber)", title: state.title)
                    }))
                }
            case .getDealsResult(.success(let response)):
                state.deals = response
                return .none
            case .getDealsResult(.failure):
                // TODO: Present alert
                return .none
            case .getMoreDeals:
                state.pageNumber += 1
                return .run { [state] send in
                    await send(.getMoreDealsResult(TaskResult {
                        try await dealsProvider.getDeals(page: "\(state.pageNumber)", title: state.title)
                    }))
                }
            case .getMoreDealsResult(.success(let response)):
                state.deals.append(contentsOf: response)
                return .none
            case .getMoreDealsResult(.failure):
                return .none
            case .binding(\.title):
                return .send(.getDeals)
                    .debounce(id: DebounceId.searchDebounce, for: .seconds(0.5), scheduler: mainQueue)
                    .cancellable(id: DebounceId.searchDebounce)
            case .binding:
                return .none
            }
        }
    }
}
