//
//  Weather.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

struct TopLevelWeatherDict: Decodable {
    let name: String
    let weather: Weather
    let tempInfo: Main
    
    private enum CodingKeys: String, CodingKey {
        case name
        case weather
        case tempInfo = "main"
    }
}

struct Weather: Decodable {
    let icon: String
    let description: String
}

struct Main: Decodable {
    let temp: Double
    let low: Double
    let high: Double
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case low = "min_temp"
        case high = "max_temp"
    }
}
