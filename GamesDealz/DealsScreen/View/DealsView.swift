//
//  DealsView.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import Foundation
import Kingfisher
import SwiftUI

public struct DealsView: View {
    @Bindable private var store: StoreOf<DealsReducer>

    public init(store: StoreOf<DealsReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search deals", text: .constant(""))
                    .disableAutocorrection(true)
                    .foregroundColor(.primary)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top)

            if store.deals.isEmpty {
                List {
                    ForEach(0 ..< 15, id: \.self) { _ in
                        DealPlaceholderCell()
                            .opacity(store.deals.isEmpty ? 0.3 : 0.7)
                            .animation(
                                .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true),
                                value: store.deals.isEmpty
                            )
                    }
                }
            } else {
                List {
                    ForEach(store.deals, id: \.id) { item in
                        cell(deal: item)
                    }
                }
                .refreshable {
                    store.send(.getDeals)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Dealzzz")
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder
    private func cell(deal: Deal) -> some View {
        HStack(alignment: .top) {
            KFImage(URL(string: deal.thumb))
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 44)
                .cornerRadius(6)
                .padding(.leading, -8)

            VStack(alignment: .leading) {
                Text(deal.title)
                    .font(.system(size: 15, weight: .bold))
                    .padding(.leading)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(deal.normalPrice)
                            .strikethrough()
                            .font(.system(size: 12))
                        Text(deal.salePrice)
                            .font(.system(size: 14, weight: .bold))
                    }
                    Text("-\(deal.savings.prefix(2))%")
                        .padding(3)
                        .background(Color.green)
                        .cornerRadius(4)
                }
            }
        }
    }
}

private struct DealPlaceholderCell: View {
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 88, height: 44)
                .cornerRadius(6)
                .padding(.leading, -8)

            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 15)
                    .cornerRadius(4)
                    .padding(.leading)

                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(width: 40, height: 12)
                            .cornerRadius(3)
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 14)
                            .cornerRadius(3)
                    }
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 30, height: 20)
                        .cornerRadius(4)
                        .padding(.trailing, 12)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    DealsView(
        store: .init(
            initialState: DealsReducer.State(),
            reducer: { DealsReducer() }
        )
    )
}
