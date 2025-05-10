//
//  StoreRepository.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture

public actor StoreRepository {
    private var stores: [Store]

    @Dependency(\.storeProvider) private var storeProvider

    public init(stores: [Store] = []) {
        self.stores = stores
    }

    func getStores() -> [Store] {
        return stores
    }

    func refreshStores() async throws {
        stores = try await storeProvider.getStores()
    }

    func getStoreById(id: String) -> Store? {
        stores.first { store in
            store.id == id
        }
    }
}

public struct StoreRepositoryDependencyKey: DependencyKey {
    public static var liveValue: StoreRepository = .init()
}

extension DependencyValues {
    var storeRepository: StoreRepository {
        get { self[StoreRepositoryDependencyKey.self] }
        set { self[StoreRepositoryDependencyKey.self] = newValue }
    }
}
