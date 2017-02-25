//
//  Api.swift
//  TrainSeeker
//
//  Created by jufina on 25.12.16.
//  Copyright © 2016 Юлия Самощенко. All rights reserved.
//

import Foundation

final class WeatherApi {
    static let apiKey = "aa3a49bd1ad8f3d3b12495a3611e21b8"
    static let baseUrl = URL(string: "http://api.openweathermap.org/")
    static let manager: RKObjectManager = WeatherApi.createManager(url: baseUrl!)
    
    static func createManager(url: URL) -> RKObjectManager {
        let client = AFRKHTTPClient(baseURL: url)
        let manager = RKObjectManager(httpClient: client)
        manager!.addResponseDescriptors(from: [ WeatherEndpoint.responseDescriptors() ])
        
        return manager!
    }
    
}

final class LocationApi {
    static let apiKey = "AIzaSyDkH4O6Gsm7jUu5TbKJjEbkZiwYlURxr9Y"
    
}

final class ImagesApi {
    static let apiKey = "AIzaSyDkH4O6Gsm7jUu5TbKJjEbkZiwYlURxr9Y"
    static let baseUrl = URL(string: "https://www.googleapis.com/")
    static let manager: RKObjectManager = ImagesApi.createManager(url: baseUrl!)
    
    static func createManager(url: URL) -> RKObjectManager {
        let client = AFRKHTTPClient(baseURL: url)
        let manager = RKObjectManager(httpClient: client)
        manager!.addResponseDescriptor(SearchEndpoint.responseDescriptors())
        
        return manager!
    }
}
