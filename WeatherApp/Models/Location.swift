//
//  Location.swift
//  WeatherApp
//
//  Created by jufina on 23.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import RealmSwift
import Realm

struct LocationAttributes {
    static let administrativeArea = "administrativeArea"
    static let subAdministrativeArea = "subAdministrativeArea"
    static let country = "country"
    static let countryCode = "countryCode"
    static let city = "city"
    static let identifier = "identifier"
}

class Location: Object {
    dynamic var administrativeArea: String?
    dynamic var subAdministrativeArea: String?
    dynamic var country: String?
    dynamic var countryCode: String?
    dynamic var city: String!
    dynamic var identifier: String!
    dynamic var imageLink: String!
    dynamic var weather: Weather!
    dynamic var formattedLocation: String!
    
    override class func primaryKey() -> String? {
        return LocationAttributes.identifier
    }

    
    //MARK: - Calculations
    func calculateFormattedLocation() {
        var resultString = String()
        if self.country != nil {
            resultString.append(self.country! + ", ")
        }
        if self.administrativeArea != nil {
            resultString.append(self.administrativeArea! + ", ")
        }
        if self.subAdministrativeArea != nil {
            resultString.append(self.subAdministrativeArea! + ", ")
        }
        resultString.append(self.city)
        
        self.formattedLocation = resultString
    }
    
    
    
}


private protocol LocationMapping {
    func locationFromGMSPlace(place: GMSPlace)
    func locationFromCLPlace(place: CLPlacemark)
}

//MARK: - LocationMapping
extension Location: LocationMapping {
    func locationFromGMSPlace(place: GMSPlace) {
        let addrComponents = place.addressComponents
        for component in addrComponents! {
            switch (component.type) {
            case "locality":
                self.city = component.name
            case "administrative_area_level_1":
                self.administrativeArea = component.name
            case "administrative_area_level_2":
                self.subAdministrativeArea = component.name
            case "administrative_area_level_3":
                self.city = self.city == nil ? component.name : self.city
            case "country":
                self.country = component.name
            default:
                break
            }
        }
        guard self.country != nil else { return }
        self.countryCode = CountryCodeConverter.getCode(for: self.country!)
        calculateFormattedLocation()
    }
    
    func locationFromCLPlace(place: CLPlacemark) {
        self.administrativeArea = place.administrativeArea ?? ""
        self.subAdministrativeArea = place.subAdministrativeArea ?? ""
        self.city = place.locality ?? ""
        self.country = place.country ?? ""
        self.countryCode = place.isoCountryCode ?? ""
        calculateFormattedLocation()
    }

}
