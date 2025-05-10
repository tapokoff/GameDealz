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
        
        public var isLoading = false
        
        public var stores: [Store]

        public var title: String = ""
        
        public init(stores: [Store]) {
            self.stores = stores
        }
    }

    public enum Action: Equatable, BindableAction {
        case onAppear
        
        case getMoreDeals
        case getMoreDealsResult(TaskResult<[Deal]>)
        
        case getDeals
        case getDealsResult(TaskResult<[Deal]>)

        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case openDealDetail(DealDetailReducer.State)
            case showAlert
        }
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
                state.isLoading = true
                return .run { [state] send in
                    await send(.getDealsResult(TaskResult {
                        try await dealsProvider.getDeals(page: "\(state.pageNumber)", title: state.title)
                    }))
                }
            case .getDealsResult(.success(let response)):
                state.deals = response
                state.isLoading = false
                return .none
            case .getDealsResult(.failure):
                state.isLoading = false
                // TODO: Present alert
                return .none
            case .getMoreDeals:
                state.isLoading = true
                state.pageNumber += 1
                return .run { [state] send in
                    await send(.getMoreDealsResult(TaskResult {
                        try await dealsProvider.getDeals(page: "\(state.pageNumber)", title: state.title)
                    }))
                }
            case .getMoreDealsResult(.success(let response)):
                state.isLoading = false
                state.deals.append(contentsOf: response)
                return .none
            case .getMoreDealsResult(.failure):
                state.isLoading = false
                return .none
            case .binding(\.title):
                return .send(.getDeals)
                    .debounce(id: DebounceId.searchDebounce, for: .seconds(0.5), scheduler: mainQueue)
                    .cancellable(id: DebounceId.searchDebounce)
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
