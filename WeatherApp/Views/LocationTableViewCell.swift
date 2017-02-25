//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation


class LocationTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!

    static func height() -> CGFloat {
        return Constants.UI.locationCellHeight
    }
}

private protocol Configuration {
    func configure(with location: Location)
}

//MARK: - Configuration
extension LocationTableViewCell: Configuration {
    func configure(with location: Location) {
        cityLabel.text = location.city
        tempLabel.text = location.weather.temp
    }
}
