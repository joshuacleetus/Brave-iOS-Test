//
//  RootFeature.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import ComposableArchitecture

struct RootState {
    var cryptoState = CryptoState()
}

enum RootAction {
    case cryptoAction(CryptoAction)
}

struct RootEnvironment { }

// swiftlint:disable trailing_closure
let rootReducer = Reducer<
    RootState,
    RootAction,
    SystemEnvironment<RootEnvironment>
>.combine(
    // 1
    cryptoReducer.pullback(
        // 2
        state: \.cryptoState,
        // 3
        action: /RootAction.cryptoAction,
        // 4
        environment: { _ in
                .live(
                    environment: CryptoEnvironment(cryptoRequest: cryptoEffect))
        }))
// swiftlint:enable trailing_closure
