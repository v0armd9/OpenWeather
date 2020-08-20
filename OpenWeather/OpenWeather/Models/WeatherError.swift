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
    
    var errorDescription: String {
        switch self {
        case .dataTaskError(let error):
            return error.localizedDescription
        case .noData:
            return "No data was returned from the weather service"
        case .jsonDecodeError(let error):
            return error.localizedDescription
        case .imageDecodeError:
            return "We were unable to fetch an image"
        case .invalidURL:
            return "There was a problem with the URL passed to the weather service"
        }
    }
}
