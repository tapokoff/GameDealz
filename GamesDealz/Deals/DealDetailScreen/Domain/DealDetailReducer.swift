//
//  DealDetailReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct DealDetailReducer {
    @ObservableState
    public struct State: Equatable {
        public var dealDetail: DealDetail = .init(gameInfo: .init(storeId: "",
                                                                  name: "",
                                                                  salePrice: "",
                                                                  steamRatingText: "",
                                                                  steamRatingPercent: "",
                                                                  metacriticScore: "",
                                                                  metacriticLink: nil,
                                                                  publisher: "",
                                                                  thumb: ""),
                                                  cheaperStores: [])
        public var dealId: String
        
        public var stores: [Store]
        
        public var isLoading = false
        
        public init(dealId: String, stores: [Store]) {
            self.dealId = dealId
            self.stores = stores
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case getDealDetail
        case getDealDetailResult(TaskResult<DealDetail>)
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case openDealDetail(DealDetailReducer.State)
            case showAlert
        }
    }
    
    @Dependency(\.dealsProvider) private var dealsProvider
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.getDealDetail)
            case .getDealDetail:
                state.isLoading = true
                return .run { [state] send in
                    await send(.getDealDetailResult(TaskResult {
                        try await dealsProvider.getDealDetail(id: state.dealId)
                    }))
                }
            case .getDealDetailResult(.success(let result)):
                state.dealDetail = result
                state.isLoading = false
                return .none
            case .getDealDetailResult(.failure):
                // TODO: present error
                state.isLoading = false
                return .none
            case .delegate:
                return .none
            }
        }
        ._printChanges()
    }
}
