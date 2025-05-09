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
        public var dealsState = DealsReducer.State()
        
        public var tabBarSelection: CustomTabViewElements = .deals
        
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case dealsAction(DealsReducer.Action)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.dealsState, action: \.dealsAction) {
            DealsReducer()
        }
        
        BindingReducer()
        
        Reduce { _, action in
            switch action {
            case .dealsAction:
                return .none
            case .binding:
                return .none
            }
        }
        ._printChanges()
    }
}
