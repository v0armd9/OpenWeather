//
//  WeatherController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation
import UIKit

struct WeatherConstants {
    fileprivate static let baseURLString = "api.openweathermap.org/data/2.5"
    fileprivate static let weatherComponent = "weather"
    fileprivate static let cityStateQueryName = "q"
    fileprivate static let zipQueryName = "zip"
    fileprivate static let apiKeyQueryName = "appid"
    fileprivate static let apiKeyValue = "da65fafb6cb9242168b7724fb5ab75e7"
    fileprivate static let iconImageComponent = "img"
    fileprivate static let weatherImageComponent = "w"
    fileprivate static let iconImageExtension = "png"
}

class WeatherController {
    
    static func fetchWeatherBy(city: String, andState state: String, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        guard var baseURL = URL(string: WeatherConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        baseURL.appendPathComponent(WeatherConstants.weatherComponent)
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let cityStateQuery = URLQueryItem(name: WeatherConstants.cityStateQueryName, value: "\(city),\(state)")
        let apiKeyQuery = URLQueryItem(name: WeatherConstants.apiKeyQueryName, value: WeatherConstants.apiKeyValue)
        urlComponents?.queryItems = [cityStateQuery, apiKeyQuery]
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        
        WeatherAPIService.fetchWeatherWith(url: finalURL) { (result) in
            return completion(result)
        }
    }
    
    static func fetchWeatherBy(zipCode: Int, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        guard var baseURL = URL(string: WeatherConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        baseURL.appendPathComponent(WeatherConstants.weatherComponent)
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let zipCodeQuery = URLQueryItem(name: WeatherConstants.zipQueryName, value: String(zipCode))
        let apiKeyQuery = URLQueryItem(name: WeatherConstants.apiKeyQueryName, value: WeatherConstants.apiKeyValue)
        urlComponents?.queryItems = [zipCodeQuery, apiKeyQuery]
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        
        WeatherAPIService.fetchWeatherWith(url: finalURL) { (result) in
            return completion(result)
        }
    }
    
    static func fetchWeatherIcon(iconCode: String, completion: @escaping (Result<UIImage, WeatherError>) -> Void) {
        guard var baseURL = URL(string: WeatherConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        baseURL.appendPathComponent(WeatherConstants.iconImageComponent)
        baseURL.appendPathComponent(WeatherConstants.weatherImageComponent)
        baseURL.appendPathComponent(iconCode)
        baseURL.appendPathExtension(WeatherConstants.iconImageExtension)
        
        WeatherAPIService.fetchIconImageWith(url: baseURL) { (result) in
            return completion(result)
        }
    }
}