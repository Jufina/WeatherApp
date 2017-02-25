//
//  SearchResultEndpoint.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

class SearchEndpoint {
    //MARK: - Path
    static let searchPath = "customsearch/v1"
    
    //MARK: - Mapping
    static func responseMapping() -> RKObjectMapping {
        let mapping: RKObjectMapping = RKObjectMapping(for: ImageSearchResult.self)
        mapping.forceCollectionMapping = true
        mapping.addAttributeMappings(from: ["title"                        : ImageSearchResultAttributes.title,
                                            "pagemap.cse_image.src"        : ImageSearchResultAttributes.rawLinks ])
        
        return mapping
    }
    
    //MARK: - Descriptor
    static func responseDescriptors() -> RKResponseDescriptor {
        return RKResponseDescriptor(mapping: responseMapping(), method: .GET, pathPattern: nil, keyPath: "items", statusCodes: nil)
    }

}
