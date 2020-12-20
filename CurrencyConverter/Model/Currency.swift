//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import UIKit

struct Currency {
    
    init(code: String, fraction: Double) {
        self.code = code
        self.countryCode = CountryCodeHelper.countryCode(forCurrencyCode: code)
        self.emoji = CountryCodeHelper.getEmoji(forCurrencyCode: code)
        self.fraction = String(format: "%.3f", fraction)
        self.image = String(emoji).image()
    }
    
    let code: String
    let countryCode: String?
    let emoji: Character!
    let image: UIImage?
    var fraction: String
    
}
