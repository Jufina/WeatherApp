//
//  Error.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

enum Error: Swift.Error {
    case NoImage
    case RepeatedData
    case NoNetwork
    case ApiCallError
}
