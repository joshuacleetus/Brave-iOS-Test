//
//  CoinTrackerTests.swift
//  CoinTrackerTests
//
//  Created by Joshua Cleetus on 1/8/22.
//

import XCTest
import ComposableArchitecture
@testable import CoinTracker

class CoinTrackerTests: XCTestCase {
    
    let testScheduler = DispatchQueue.test
    var testCryptos: [CryptoModel] {
        [
            CryptoModel(symbol: "btc",
                        name: "Bitcoin",
                        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                        currentPrice: 42061,
                        bitcoinPrice: 1.0)
        ]
    }
    
    func testCryptoEffect(decoder: JSONDecoder) -> Effect<[CryptoModel], APIError> {
        return Effect(value: testCryptos)
    }
    
    func testOnAppear() {
        let store = TestStore(
            initialState: CryptoState(),
            reducer: cryptoReducer,
            environment: SystemEnvironment(
                environment: CryptoEnvironment(
                    cryptoRequest: testCryptoEffect),
                mainQueue: { self.testScheduler.eraseToAnyScheduler() },
                decoder: { JSONDecoder() }))
        
        store.send(.onAppear)
        testScheduler.advance()
        store.receive(.dataLoaded(.success(testCryptos))) { [self] state in
            var btcPrice: Double = 0.0
            if let btc = self.testCryptos.first, let btcCurrent = btc.currentPrice {
                btcPrice = btcCurrent
            }
            state.cryptoCoins = self.testCryptos.map({
                var crypto = $0
                if let currentPrice = crypto.currentPrice {
                    crypto.bitcoinPrice = currentPrice/btcPrice
                }
                return crypto
            })
            state.cryptoCoins = self.testCryptos
        }
    }
    
}
