//
//  LocationService.swift
//  WeatherApp
//
//  Created by jufina on 23.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import GooglePlaces
import BrightFutures
import Result
import Realm
import RealmSwift

class LocationService: NSObject {
    static let shared = LocationService()
    
    var currentLocation: Location!
    let locationManager = CLLocationManager()
    
    //MARK: - Helpers
    func showCurrentLocationAlert() {
        let alert = UIAlertController(title: "Локация", message: currentLocation.formattedLocation, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.addCurrentLocation()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways) {
            startUpdatingLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let geoCoder = CLGeocoder();
        geoCoder.reverseGeocodeLocation(locations.first!) { [unowned self] (placemarks, error) in
            guard error == nil else { return }
            for placemark in placemarks! {
                let location = Location()
                location.locationFromCLPlace(place: placemark)
                guard self.currentLocation == nil else { return }
                self.currentLocation = location
                self.showCurrentLocationAlert()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    
}

private protocol Setup {
    func setupLocationManager()
    func setupCurrentLocation()
}

private protocol LocationManagement {
    func addNew(location: Location, successBlock: @escaping (_ locationId: String) -> Void)
    func addCurrentLocation()
    func save(location: Location)
    func startUpdatingLocation()
}

//MARK: - LocationManagement
extension LocationService: LocationManagement {
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func addCurrentLocation() {
        addNew(location: self.currentLocation, successBlock: { locationId in
            UserDefaults.standard.set(locationId, forKey: "CurrentLocationId")
        })
        
    }
    
    func addNew(location: Location, successBlock: @escaping (_ locationId: String) -> Void) {
        WeatherService.shared.getWeather(in: location)
            .flatMap({ (weather) -> Future<Weather, Error> in
                let locationId = weather.cityId
                let realm = try! Realm()
                if let _ = realm.object(ofType: Location.self, forPrimaryKey: locationId) {
                    return Future(error: Error.RepeatedData)
                }
                location.identifier = locationId
                return Future(value: weather)
            })
            .flatMap { (weather) -> Future<String, Error> in
                location.weather = weather
                return ImageService.shared.downloadImage(for: location)
            }
            .onSuccess { [unowned self] (link) in
                location.imageLink = link
                self.save(location: location)
                successBlock(location.identifier)
            }
            .onFailure { (error) in
                switch (error) {
                case .ApiCallError:
                    AlertManager.showError(title: "Error", message: "Can't find weather for this city")
                case .NoImage:
                    AlertManager.showError(title: "Error", message: "No image found")
                case .RepeatedData:
                    AlertManager.showWarning(title: "Error", message: "City added to list already")
                case .NoNetwork:
                    AlertManager.showError(title: "Error", message: "No network")
                }
        }
    }
    
    fileprivate func save(location: Location) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(location, update: true)
        }
    }

}

//MARK: - Setup
extension LocationService: Setup {
    func setupLocationManager() {
        setupCurrentLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    func setupCurrentLocation() {
        if self.currentLocation == nil {
            if let identifier = UserDefaults.standard.value(forKey: "CurrentLocationId") {
                let realm = try! Realm()
                self.currentLocation = realm.object(ofType: Location.self, forPrimaryKey: identifier)
            }
        }
    }
}
