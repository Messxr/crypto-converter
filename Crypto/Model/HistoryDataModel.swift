//
//  History.swift
//  Crypto
//
//  Created by Daniil Marusenko on 15.03.2021.
//

import Foundation

struct HistoryDataModelElement: Codable {
    let priceClose: Double

    enum CodingKeys: String, CodingKey {
        case priceClose = "price_close"
    }
}

typealias HistoryDataModel = [HistoryDataModelElement]
