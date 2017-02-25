//
//  ViewController.swift
//  WeatherApp
//
//  Created by jufina on 23.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import UIKit
import CoreLocation
import Realm
import RealmSwift
import GooglePlaces

let showWeatherSegueIdentifier = "showWeatherSegueIdentifier"

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    
    var locations: Results<Location>! = nil
    var token: NotificationToken!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupLocations()
        setupTableView()
        setupNotificationsToken()
        LocationService.shared.setupLocationManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWeatherSegueIdentifier {
            let location = sender as! Location
            let destVC = segue.destination as! WeatherDetailsViewController
            destVC.location = location
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        navigateToGMSAutocompleteController()
    }
    
}


//MARK: - GMSAutocompleteViewControllerDelegate
extension LocationsViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let location = Location()
        location.locationFromGMSPlace(place: place)
        _ = LocationService.shared.addNew(location: location, successBlock: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Swift.Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate
extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        self.performSegue(withIdentifier: showWeatherSegueIdentifier, sender: location)
        self.citiesTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationTableViewCell.height()
    }
}

//MARK: - UITableViewDataSource
extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.citiesTableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier) as? LocationTableViewCell
        let location = locations[indexPath.row]
        cell!.configure(with: location)
        
        return cell!
    }
}
//MARK: -


private protocol Setup {
    func setupTableView()
    func setupLocations()
    func setupNotificationsToken()
}

private protocol Navigation {
   func navigateToGMSAutocompleteController()
}

//MARK: - Navigation
extension LocationsViewController: Navigation {
    func navigateToGMSAutocompleteController() {
        let autoCompleteVC = GMSAutocompleteViewController()
        autoCompleteVC.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autoCompleteVC.autocompleteFilter = filter
        self.present(autoCompleteVC, animated: true, completion: nil)
    }
}

//MARK: - Setup
extension LocationsViewController: Setup {
    fileprivate func setupTitle() {
        self.title = "Список"
    }
    fileprivate func setupTableView() {
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    fileprivate func setupLocations() {
        let realm = try! Realm()
        self.locations = realm.objects(Location.self)
    }
    
    fileprivate func setupNotificationsToken() {
        token = self.locations.addNotificationBlock({ (changes) in
            switch (changes) {
                case .initial:
                    self.citiesTableView.reloadData()
                    break
                case .update(_, let deletions, let insertions, let modifications):
                    self.citiesTableView.beginUpdates()
                    self.citiesTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.citiesTableView.endUpdates()
                    break
                default:
                    break
                }
            })
    }

}
