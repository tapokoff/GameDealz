//
//  Navigation.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Navigation {
    @ObservableState
    public struct State: Equatable {
        public var splashScreenState = SplashScreenReducer.State()
        
        var path = StackState<Path.State>()
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case splashScreenAction(SplashScreenReducer.Action)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.splashScreenState, action: \.splashScreenAction) {
            SplashScreenReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .splashScreenAction(.delegate(let action)):
                switch action {
                case .openHomeScreen:
                    state.path.append(.homeScreen(.init()))
                    return .none
                case .showAlert:
                    return .none
                }
            case .splashScreenAction:
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    @Reducer
    public struct Path {
        @ObservableState
        public enum State: Equatable {
            case homeScreen(HomeReducer.State = .init())
        }
        
        public enum Action: Equatable {
            case homeScreen(HomeReducer.Action)
        }
        
        public init() {}
        
        public var body: some Reducer<State, Action> {
            Scope(state: \.homeScreen, action: \.homeScreen) {
                HomeReducer()
            }
        }
    }
}
