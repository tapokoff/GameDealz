//
//  URLSession+dependency.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import ComposableArchitecture
import Foundation

public struct URLSessionDependencyKey: DependencyKey {
    public static var liveValue: URLSessionProtocol = URLSession.shared
}

extension DependencyValues {
    var urlSession: URLSessionProtocol {
      get { self[URLSessionDependencyKey.self] }
      set { self[URLSessionDependencyKey.self] = newValue }
    }
}
