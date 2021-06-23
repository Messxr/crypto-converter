//
//  CryptoModel.swift
//  Crypto
//
//  Created by Daniil Marusenko on 26.02.2021.
//

import Foundation

struct CryptoDataModel: Codable {
    let result: Result
}

struct Result: Codable {
    let price: Double
}
