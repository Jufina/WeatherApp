//
//  ImageService.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import BrightFutures
import Result

class ImageService {
    static let shared = ImageService()

    func downloadImage(for location: Location) -> Future<String, Error> {
        let queryString = location.formattedLocation
        let params = ["q" : queryString,
                      "cx": Constants.Api.findSystemIdentifier,
                      "searchtype": "images",
                      "key" : ImagesApi.apiKey ]
        return Future<String, Error> { complete in
            ImagesApi.manager.getObjectsAtPath(SearchEndpoint.searchPath, parameters: params, success: { (operation, mappingResult) in
                let searchResults = mappingResult?.array() as! [ImageSearchResult]
                var imageUrl: String?
                for searchResult in searchResults {
                    guard searchResult.rawLinks != nil else { continue }
                    for rawLink in searchResult.rawLinks {
                        guard let link = rawLink as? String else { continue }
                        imageUrl = link
                        break
                    }
                    if imageUrl != nil {
                        break
                    }
                }
                guard imageUrl != nil else {
                    return complete(.failure(Error.NoImage))
                }
                complete(.success(imageUrl!))
            }) { (operation, error1) in
                complete(.failure(Error.ApiCallError))
            }
        }
        
    }
}
