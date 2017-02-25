//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by jufina on 25.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation


class WeatherTableViewCell: UITableViewCell, Reusable {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private protocol Configuration {
    func configure(title: String, details: String)
}

//MARK: - Configuration
extension WeatherTableViewCell: Configuration {
    func configure(title: String, details: String) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = details
    }
}
