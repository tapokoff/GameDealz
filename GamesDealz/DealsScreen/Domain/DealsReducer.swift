//
//  DealsReducer.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

@Reducer
public struct DealsReducer {
    @ObservableState
    public struct State: Equatable {
        public var deals: [Deal] = []
    }

    public enum Action: Equatable {
        case onAppear
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.deals = [
                    .init(title: "NBA 2K25",
                          id: "wKOEl4x7sotYAaxRPLdNVe2WZumv5lcI16ncAUovpQM%3D1",
                          storeId: "3",
                          salePrice: "9.79",
                          normalPrice: "69.99",
                          savings: "86.012287",
                          thumb: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2878980/capsule_sm_120.jpg?t=1743778894"),
                    .init(title: "NBA 2K25",
                          id: "wKOEl4x7sotYAaxRPLdNVe2WZumv5lcI16ncAUovpQM%3D1",
                          storeId: "3",
                          salePrice: "9.79",
                          normalPrice: "69.99",
                          savings: "86.012287",
                          thumb: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2878980/capsule_sm_120.jpg?t=1743778894"),
                    .init(title: "NBA 2K25",
                          id: "wKOEl4x7sotYAaxRPLdNVe2WZumv5lcI16ncAUovpQM%3D1",
                          storeId: "3",
                          salePrice: "9.79",
                          normalPrice: "69.99",
                          savings: "86.012287",
                          thumb: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2878980/capsule_sm_120.jpg?t=1743778894"),
                    .init(title: "NBA 2K25",
                          id: "wKOEl4x7sotYAaxRPLdNVe2WZumv5lcI16ncAUovpQM%3D1",
                          storeId: "3",
                          salePrice: "9.79",
                          normalPrice: "69.99",
                          savings: "86.012287",
                          thumb: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2878980/capsule_sm_120.jpg?t=1743778894"),
                    .init(title: "NBA 2K25",
                          id: "wKOEl4x7sotYAaxRPLdNVe2WZumv5lcI16ncAUovpQM%3D1",
                          storeId: "3",
                          salePrice: "9.79",
                          normalPrice: "69.99",
                          savings: "86.012287",
                          thumb: "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2878980/capsule_sm_120.jpg?t=1743778894"),
                ]
                return .none
            }
        }
    }
}
