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
            searchBar()

            if store.deals.isEmpty {
                placeholderList()
            } else {
                dealsList()
            }
        }
        .navigationTitle("Dealzzz")
        .onAppear { store.send(.onAppear) }
    }
}

private extension DealsView {
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
    func placeholderList() -> some View {
        List {
            ForEach(0..<15, id: \.self) { _ in
                DealPlaceholderCell()
                    .opacity(0.3)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true),
                        value: store.deals.isEmpty
                    )
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    func dealsList() -> some View {
        List {
            ForEach(store.deals.indices, id: \.self) { idx in
                dealRow(for: store.deals[idx], at: idx)
            }
        }
        .id(store.title)
        .listStyle(.plain)
        .refreshable { store.send(.getDeals) }
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    func dealRow(for deal: Deal, at idx: Int) -> some View {
        dealCell(deal: deal)
            .onAppear {
                guard
                    idx == store.deals.count - 1,
                    store.deals.count % 60 == 0
                else { return }
                store.send(.getMoreDeals)
            }
    }

    @ViewBuilder
    func dealCell(deal: Deal) -> some View {
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

                priceSection(for: deal)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            store.send(
                .delegate(
                    .openDealDetail(
                        .init(dealId: deal.id, stores: store.stores)
                    )
                )
            )
        }
    }

    @ViewBuilder
    func priceSection(for deal: Deal) -> some View {
        HStack(alignment: .bottom) {
            let sellerStore = store.stores.first { $0.id == deal.storeId }
            KFImage(URL(string: sellerStore?.images.iconImage ?? ""))
                .padding(.leading)

            Spacer()

            if deal.salePrice == deal.normalPrice {
                Text("$\(deal.normalPrice)")
                    .font(.system(size: 14, weight: .bold))
            } else {
                VStack(alignment: .trailing) {
                    Text("$\(deal.normalPrice)")
                        .strikethrough()
                        .font(.system(size: 12))
                    Text("$\(deal.salePrice)")
                        .font(.system(size: 14, weight: .bold))
                }
                Text("-\(deal.savings.prefix(2))%")
                    .padding(3)
                    .background(Color.green)
                    .cornerRadius(4)
            }
        }
        .frame(alignment: .bottom)
    }
}

#Preview {
    DealsView(
        store: .init(
            initialState: DealsReducer.State(stores: .init()),
            reducer: { DealsReducer() }
        )
    )
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
