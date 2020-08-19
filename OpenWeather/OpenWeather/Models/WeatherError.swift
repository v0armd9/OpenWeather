//
//  WeatherError.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

enum WeatherError: LocalizedError {
    case dataTaskError(Error)
    case noData
    case jsonDecodeError(Error)
    case imageDecodeError
    case invalidURL
}
