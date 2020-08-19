//
//  WeatherDetailViewController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    var weatherDict: TopLevelWeatherDict?
    var iconImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let icon = iconImage {
            iconImageView.image = icon
        } else {
            iconImageView.isHidden = true
        }
        if let cityName = weatherDict?.name {
            cityNameLabel.text = cityName
        } else {
            cityNameLabel.text = "Unknown Location"
        }
        if let conditions = weatherDict?.weather.first?.description {
            weatherDescriptionLabel.text = conditions
        } else {
            weatherDescriptionLabel.text = ""
        }
        if let currentTemp = weatherDict?.tempInfo.temp {
            currentTempLabel.text = "\(String(currentTemp))° F"
        } else {
            currentTempLabel.text = "No Data"
        }
        if let highTemp = weatherDict?.tempInfo.high {
            highTempLabel.text = "\(String(highTemp))° F"
        } else {
            highTempLabel.text = "No Data"
        }
        if let lowTemp = weatherDict?.tempInfo.low {
            lowTempLabel.text = "\(String(lowTemp))° F"
        } else {
            lowTempLabel.text = "No Data"
        }
    }
}
