//
//  Weather.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WeatherDetails: NSObject {
    var details: String!
    var desc: String!
}

struct WeatherAttributes {
    static let temp = "temp"
    static let tempK = "_temp"
    static let pressure = "pressure"
    static let windSpeed = "windSpeed"
    static let details = "details"
    static let description = "desc"
    static let cityId = "cityId"
    static let weather = "weather"
}

class Weather: Object {
    dynamic var cityId: String!
    dynamic var _temp: NSNumber! = 0
    dynamic var pressure: String!
    dynamic var windSpeed: String!
    var weather: NSArray!
    dynamic var formattedDetails: String!
    
    var temp: String {
        get {
            return String(_temp.intValue - 273) + "℃"
        }
    }
    
    override class func primaryKey() -> String? {
        return WeatherAttributes.cityId
    }
    
    override class func ignoredProperties() -> [String] {
        return [ WeatherAttributes.weather ]
    }
    
    
    //MARK: - Calculations
    func calculateFormattedDetails() {
        var resultString = ""
        defer {
            self.formattedDetails = resultString
        }
        
        guard weather.count > 0 else { return }
        if let weatherDetails = weather[0] as? WeatherDetails {
            if weatherDetails.details != nil {
                resultString.append(weatherDetails.details + ", ")
            }
            if weatherDetails.desc != nil {
                resultString.append(weatherDetails.desc)
            }
        }
    }
}


