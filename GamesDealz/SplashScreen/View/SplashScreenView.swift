//
//  SplashScreenView.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import SwiftUI

public struct SplashScreenView: View {
    @Bindable private var store: StoreOf<SplashScreenReducer>
    
    public init(store: StoreOf<SplashScreenReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 64) {
            Image("splashScreenIcon")
            ProgressView()
                .scaleEffect(1.5)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    SplashScreenView(store: .init(initialState: SplashScreenReducer.State(), reducer: {
        SplashScreenReducer()
    }))
}
