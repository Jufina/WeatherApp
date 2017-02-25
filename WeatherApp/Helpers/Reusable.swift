//
//  Reusable.swift
//  WeatherApp
//
//  Created by jufina on 25.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String {get}
}

//MARK: - Reusable
extension Reusable {
    static var reuseIdentifier: String {
        return "\(String(describing: self))ReuseIdentifier"
    }
}
