import ComposableArchitecture
import Kingfisher
import SwiftUI

public struct DealDetailView: View {
    @Bindable private var store: StoreOf<DealDetailReducer>

    public init(store: StoreOf<DealDetailReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Group {
                if store.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading…")
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            coverImage()
                            titleAndPrice()
                            infoRows()
                            cheaperStoresSection()
                        }
                    }
                }
            }
            .navigationTitle("Deal detail")
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

private extension DealDetailView {
    @ViewBuilder
    func coverImage() -> some View {
        KFImage(
            URL(string:
                store.dealDetail.gameInfo.thumb
            )
        )
        .resizable()
        .scaledToFit()
    }

    @ViewBuilder
    func titleAndPrice() -> some View {
        HStack {
            Text(store.dealDetail.gameInfo.name)
                .font(.system(size: 24, weight: .bold))
            Spacer()
            Text("$\(store.dealDetail.gameInfo.salePrice)")
                .font(.system(size: 18, weight: .bold))
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func infoRows() -> some View {
        Group {
            let sellerStore = store.stores.first {
                $0.id == store.dealDetail.gameInfo.storeId
            }
            HStack {
                Text("Store:")
                Text(sellerStore?.name ?? "N/A")
                KFImage(URL(string: sellerStore?.images.iconImage ?? ""))
            }
            .padding(.horizontal)
            infoRow(label: "Store:", value: "Steam")
            infoRow(label: "Steam rating:", value: "\(store.dealDetail.gameInfo.steamRatingText ?? ""), \(store.dealDetail.gameInfo.steamRatingPercent)")
            infoRow(label: "Metacritic score:", value: "\(store.dealDetail.gameInfo.metacriticScore)")
            infoRow(label: "Publisher:", value: "\(store.dealDetail.gameInfo.publisher)")
        }
    }

    @ViewBuilder
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Text(value)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func cheaperStoresSection() -> some View {
        Text("Cheaper stores:")
            .font(.system(size: 20, weight: .semibold))
            .padding(.horizontal)

        if !store.dealDetail.cheaperStores.isEmpty {
            Divider()
                .padding(.horizontal)
            cheaperStoresList()
                .padding(.top, 2)
        } else {
            noCheaperStoresView()
        }
    }

    @ViewBuilder
    func cheaperStoresList() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(store.dealDetail.cheaperStores, id: \.dealId) { item in
                VStack {
                    let sellerStore = store.stores.first {
                        $0.id == item.storeId
                    }
                    HStack {
                        Text("\(sellerStore?.name ?? "N/A")")
                        KFImage(URL(string: sellerStore?.images.iconImage ?? ""))
                        Text(": $\(item.salePrice)")
                        Spacer()
                        Text(">")
                    }
                    Divider()
                        .padding(.top, 8)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.delegate(.openDealDetail(.init(dealId: item.dealId, stores: store.stores))))
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    func noCheaperStoresView() -> some View {
        Text("Not found. It's the cheapest deal!")
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top, 16)
    }
}

#Preview {
    DealDetailView(store: .init(initialState: .init(dealId: "DQ%2BYLI9do4mm0H2%2BDUd6npgoQoK8bseNvyjJe%2B%2F3dEo%3D",
                                                    stores: .init()), reducer: {
        DealDetailReducer()
    }))
}
