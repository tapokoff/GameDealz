//
//  GamesView.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 10.05.2025.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

public struct GamesView: View {
    @Bindable private var store: StoreOf<GamesReducer>

    public init(store: StoreOf<GamesReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            searchBar()

            if store.games.isEmpty {
                if store.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    Spacer()
                    Text("Nothing found...")
                    Spacer()
                }
            } else {
                gamesList()
            }
        }
        .navigationTitle("Games search")
    }
}

private extension GamesView {
    @ViewBuilder
    func searchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search deals", text: $store.title)
                .disableAutocorrection(true)
                .foregroundColor(.primary)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.top)
    }

    @ViewBuilder
    func gamesList() -> some View {
        List {
            ForEach(store.games.indices, id: \.self) { idx in
                if store.games.count == 0 {
                    EmptyView()
                } else {
                    gameRow(for: store.games[idx], at: idx)
                }
            }
        }
        .id(store.title)
        .listStyle(.plain)
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    func gameRow(for game: Game, at id: Int) -> some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: game.thumb))
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 88)
            Text(game.name)
                .font(.system(size: 24, weight: .bold))
            
            HStack {
                Text("Cheapest price: $\(game.cheapestPrice)")
            }
            HStack {
                Spacer()
                Button("Go to deal >") {
                    store.send(.delegate(.openDealDetail(.init(dealId: game.cheapestDealId,
                                                               stores: store.stores))))
                }
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GamesView(store: .init(initialState: .init(stores: .init()), reducer: {
        GamesReducer()
    }))
}
