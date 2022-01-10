//
//  CryptoFeature.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import Combine
import ComposableArchitecture

struct CryptoState: Equatable {
    var cryptoCoins: [CryptoModel] = []
    var bitcoinPrice: Double?
}

enum CryptoAction: Equatable {
    case onAppear
    case dataLoaded(Result<[CryptoModel], APIError>)
}

struct CryptoEnvironment {
    var cryptoRequest: (JSONDecoder) -> Effect<[CryptoModel], APIError>
}

let cryptoReducer = Reducer<
    CryptoState,
    CryptoAction,
    SystemEnvironment<CryptoEnvironment>
> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.cryptoRequest(environment.decoder())
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(CryptoAction.dataLoaded)
    case .dataLoaded(let result):
        print(result as Any)
        switch result {
        case .success(let cryptoCoins):
            var btcPrice: Double = 0.0
            if let btc = cryptoCoins.first, let btcCurrent = btc.currentPrice {
                btcPrice = btcCurrent
            }
            state.cryptoCoins = cryptoCoins.map({
                var crypto = $0
                if let currentPrice = crypto.currentPrice {
                    crypto.bitcoinPrice = currentPrice/btcPrice
                }
                return crypto
            })
        case .failure(let error):
            break
        }
        return .none
    }
}
