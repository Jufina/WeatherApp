//
//  WeatherService.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import BrightFutures
import Result

class WeatherService {
    static let shared = WeatherService()
    
    func getWeather(in location: Location) -> Future<Weather, Error>  {
        let params = ["q" : generatedQuery(for: location), "APPID" : WeatherApi.apiKey]
        return Future<Weather,Error> { complete in
            WeatherApi.manager.getObjectsAtPath(WeatherEndpoint.getWeatherPath, parameters: params, success: { (operation, mappingResult) in
            let weather = mappingResult?.firstObject as! Weather
            weather.calculateFormattedDetails()
            complete(.success(weather))
        }) { (operation, error) in
            complete(.failure(Error.ApiCallError))
        }
        }
    }
    
    fileprivate func generatedQuery(for location: Location) -> String {
        var resultQuery = location.city!
        if location.countryCode != nil {
            resultQuery.append(location.countryCode!)
        }
        return resultQuery
    }
}
