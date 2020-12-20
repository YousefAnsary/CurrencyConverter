//
//  CountryImojiGenerator.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import Foundation

class CountryCodeHelper {
    
    class func countryCode(forCurrencyCode code: String)-> String {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencyCode, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencyCode, value: code) ?? ""
        }
        return locale.displayName(forKey: .currencyCode, value: code) ?? ""
    }
    
    class func currencyCode(forCurrency code: String)-> String {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code) ?? ""
        }
        return locale.displayName(forKey: .currencySymbol, value: code) ?? ""
    }
    
    class func getEmoji(forCurrencyCode code: String) -> Character {
        if code == "EUR" { return "🇪🇺" }
        return flag(country: currencyCode(forCurrency: code))
    }

    class func flag(country: String) -> Character {
        let base : UInt32 = 127397
        var s = ""
        print(country)
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s).first ?? "🚫"
    }
    
}
