//
//  ContentView.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import SwiftUI

public struct NavigationRootView: View {
    @Bindable var store: StoreOf<Navigation>

    public init(store: StoreOf<Navigation>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStackStore(
                self.store.scope(state: \.path, action: \.path)
            ) {
                SplashScreenView(store: store.scope(state: \.splashScreenState, action: \.splashScreenAction))
            } destination: {
                switch $0 {
                case .homeScreen:
                    CaseLet(/Navigation.Path.State.homeScreen,
                            action: Navigation.Path.Action.homeScreen)
                    { store in
                        HomeView(store: store)
                            .navigationBarBackButtonHidden()
                    }
                case .dealDetailScreen:
                    CaseLet(/Navigation.Path.State.dealDetailScreen,
                            action: Navigation.Path.Action.dealDetailScreen)
                    { store in
                        DealDetailView(store: store)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationRootView(store: .init(initialState: .init(), reducer: {
        Navigation()
    }))
}
