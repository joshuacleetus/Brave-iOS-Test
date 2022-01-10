//
//  CryptoModel.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import Foundation

// MARK: - CryptoModel
struct CryptoModel: Decodable, Equatable {
    
    
    let symbol, name: String
    let image: String
    let currentPrice: Double?
    var bitcoinPrice: Double?
    
    private enum CodingKeys: String, CodingKey {
        case symbol, name, image
        case currentPrice = "current_price"
    }
}

extension CryptoModel: Identifiable {
    var id: String { name }
}

extension CryptoModel {
    var currentPriceString: String {
        get {
            var priceString = ""
            if let price = currentPrice {
                priceString = "$" + String(format: "%.2f", price)
            }
            return priceString
        }
    }
    
    var bitcoinPriceString: String {
        get {
            var priceString = ""
            if let price = bitcoinPrice, symbol != "btc" {
                priceString = String(format: "%.6f", price) + "BTC"
            }
            return priceString
        }
    }
}
