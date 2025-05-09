//
//  ServiceProtocolError.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import Foundation

public enum ServiceProtocolError: Error {
    case invalidURL(any ServiceProtocol)
    case responseCode(Int)
    case unexpectedResponse(HTTPURLResponse?)
}
