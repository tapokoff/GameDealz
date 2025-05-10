//
//  HomeScreenView.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    @Bindable private var store: StoreOf<HomeReducer>

    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                switch store.tabBarSelection {
                case .deals:
                    DealsView(store: store.scope(state: \.dealsState, action: \.dealsAction))
                case .games:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, alignment: .center) {
                CustomTabBar(selection: $store.tabBarSelection)
                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    HomeView(store: .init(initialState: .init(stores: .init()), reducer: {
        HomeReducer()
    }))
}
