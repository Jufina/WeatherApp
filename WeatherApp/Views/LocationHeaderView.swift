//
//  LocationHeaderView.swift
//  WeatherApp
//
//  Created by jufina on 25.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation

class LocationHeaderView: UIView {
    let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.frame = self.frame
    }
    
    static func height() -> CGFloat {
        return Constants.UI.locationHeaderHeight
    }
    
}

private protocol Setup {
    func setupLabel()
}

private protocol Configuration {
    func configure(with location: Location)
}

//MARK: - Setup
extension LocationHeaderView: Setup {
    fileprivate func setupLabel() {
        headerLabel.font = Constants.UI.locationHeaderFont
        headerLabel.textAlignment = .center
        headerLabel.frame = self.frame
        headerLabel.backgroundColor = UIColor.white
        headerLabel.numberOfLines = 3
        self.addSubview(headerLabel)
    }

}

//MARK: - Configuration
extension LocationHeaderView: Configuration {
    func configure(with location: Location) {
        headerLabel.text = location.formattedLocation
    }
}
