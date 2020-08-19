//
//  WeatherTableViewCell.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    var weatherDict: TopLevelWeatherDict? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    func updateViews() {
        guard let weatherDict = weatherDict else { return }
        cityNameLabel.text = weatherDict.name
        if let currentTempDouble = weatherDict.tempInfo.temp {
            let currentTemp = Int(currentTempDouble)
            currentTempLabel.text = "\(currentTemp)"
        } else {
            currentTempLabel.text = "No Temp Available"
        }
        iconImageView.image = nil
        if let iconCode = weatherDict.weather.first?.icon {
            WeatherController.fetchWeatherIcon(iconCode: iconCode) { (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.iconImageView.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
