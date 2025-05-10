//
//  HomeScreenReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

@Reducer
public struct HomeReducer {
    @ObservableState
    public struct State: Equatable {
        public var dealsState: DealsReducer.State
        
        public var tabBarSelection: CustomTabViewElements = .deals
        
        public var stores: [Store]
        
        public init(stores: [Store]) {
            self.stores = stores
            dealsState = .init(stores: stores)
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case dealsAction(DealsReducer.Action)
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case openDealDetail(DealDetailReducer.State)
            case showAlert
        }
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.dealsState, action: \.dealsAction) {
            DealsReducer()
        }
        
        BindingReducer()
        
        Reduce { _, action in
            switch action {
            case .dealsAction(.delegate(let action)):
                switch action {
                case .openDealDetail(let state):
                    return .send(.delegate(.openDealDetail(state)))
                case .showAlert:
                    return .none
                }
            case .dealsAction:
                return .none
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
        ._printChanges()
    }
}
