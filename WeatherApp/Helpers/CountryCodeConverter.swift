//
//  CountryCodeConverter.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

class CountryCodeConverter {

    static func getCode(for country: String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode)
            if country.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
    
}
