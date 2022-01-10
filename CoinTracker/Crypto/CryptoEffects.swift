//
//  CryptoEffects.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import Foundation
import ComposableArchitecture

func cryptoEffect(decoder: JSONDecoder) -> Effect<[CryptoModel], APIError> {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin%2C%20ethereum%2C%20binancecoin%2C%20basic-attention-token&order=market_cap_desc&per_page=100&page=1&sparkline=false") else {
        fatalError("Error on creating url")
    }
    return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { _ in APIError.downloadError }
        .map { data, _ in data }
        .decode(type: [CryptoModel].self, decoder: decoder)
        .mapError { _ in APIError.decodingError }
        .eraseToEffect()
}

func dummyRepositoryEffect(decoder: JSONDecoder) -> Effect<[CryptoModel], APIError> {
    let dummyRepositories = [
        CryptoModel(symbol: "btc",
                    name: "Bitcoin",
                    image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                    currentPrice: 42061),
        CryptoModel(symbol: "eth",
                    name: "Ethereum",
                    image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
                    currentPrice: 3140.69)
    ]
    return Effect(value: dummyRepositories)
}

