//
//  SearchImageResult.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

struct ImageSearchResultAttributes {
    static let title = "title"
    static let rawLinks = "rawLinks"
}

class ImageSearchResult: NSObject {
    var title: String!
    var rawLinks: NSArray!
}
