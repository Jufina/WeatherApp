//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

class WeatherEndpoint {
    //MARK: - Path
    static let getWeatherPath = "data/2.5/weather"
    
    //MARK: - Mapping
    static func detailsMapping() -> RKObjectMapping {
        let mapping: RKObjectMapping = RKObjectMapping(for: WeatherDetails.self)
        mapping.addAttributeMappings(from: [ "main"        : WeatherAttributes.details,
                                            "description" : WeatherAttributes.description,
                                            ])
        
        return mapping
    }

    static func responseMapping() -> RKObjectMapping {
        let mapping: RKObjectMapping = RKObjectMapping(for: Weather.self)
        mapping.addAttributeMappings(from: ["main.temp"           : WeatherAttributes.tempK,
                                            "id"                  : WeatherAttributes.cityId,
                                            "wind.speed"          : WeatherAttributes.windSpeed,
                                            "main.pressure"       : WeatherAttributes.pressure
                                            ])
        
        mapping.addRelationshipMapping(withSourceKeyPath: "weather", mapping: detailsMapping())
        
        return mapping
    }
    
    //MARK: - Descriptor
    static func responseDescriptors() -> RKResponseDescriptor {
        return RKResponseDescriptor(mapping: responseMapping(), method: .GET, pathPattern: nil, keyPath: "", statusCodes: nil)
    }
}
