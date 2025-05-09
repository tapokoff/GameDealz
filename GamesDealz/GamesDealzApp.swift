//
//  GamesDealzApp.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import SwiftUI

@main
struct GamesDealzApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationRootView(store: .init(initialState: .init(), reducer: {
                Navigation()
            }))
        }
    }
}
