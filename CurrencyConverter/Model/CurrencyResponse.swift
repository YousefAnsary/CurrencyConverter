//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import Foundation

struct CurrencyResponse: Codable {
    let success: Bool?
    let timestamp: Int?
    let base: String?
    let date: Date?
    var rates: [String: Double]?
}
