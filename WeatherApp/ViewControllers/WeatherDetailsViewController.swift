//
//  AddingLocationViewController.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import SDWebImage

class WeatherDetailsViewController: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var weatherInfoTableView: UITableView!
    var locationHeaderView: LocationHeaderView!
    
    var details: [String]!
    var params: [String]!
    var location: Location!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupDetails()
        setupLocationImageView()
        setupHeaderView()
        setupTableView()
    }
}

private protocol Setup {
    func setupTitle()
    func setupDetails()
    func setupLocationImageView()
    func setupHeaderView()
    func setupTableView()
}

//MARK: - Setup
extension WeatherDetailsViewController: Setup {
    fileprivate func setupTitle() {
        self.title = self.location.city
    }
    fileprivate func setupDetails() {
        let weather = self.location.weather!
        self.details = [ weather.temp, weather.pressure, weather.windSpeed, weather.formattedDetails ]
        self.params = [ "Температура", "Давление", "Скорость ветра", "Описание" ]
    }
    
    fileprivate func setupLocationImageView() {
        locationImageView.backgroundColor = UIColor.groupTableViewBackground
        locationImageView.contentMode = .scaleToFill
        guard let url = URL(string: location.imageLink) else { return }
        locationImageView.sd_setImage(with: url)
    }
    
    fileprivate func setupHeaderView() {
        self.locationHeaderView = LocationHeaderView()
        self.locationHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.locationHeaderView.configure(with: self.location)
    }
    
    fileprivate func setupTableView() {
        self.weatherInfoTableView.isScrollEnabled = false
        self.weatherInfoTableView.layer.cornerRadius = 4
        self.weatherInfoTableView.backgroundColor = UIColor.white
        self.weatherInfoTableView.delegate = self
        self.weatherInfoTableView.dataSource = self
    }
}

//MARK: - UITableViewDelegate
extension WeatherDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.locationHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LocationHeaderView.height()
    }
}

//MARK: - UITableViewDataSource
extension WeatherDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifier) as? WeatherTableViewCell
        if cell == nil {
            cell = WeatherTableViewCell(style: .value2, reuseIdentifier: WeatherTableViewCell.reuseIdentifier)
        }
        cell!.configure(title: params[indexPath.row], details: self.details[indexPath.row])
        
        return cell!
    }
    
}
