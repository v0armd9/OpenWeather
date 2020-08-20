//
//  WeatherController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String Constants
struct WeatherConstants {
    fileprivate static let baseURLString = "https://api.openweathermap.org/"
    fileprivate static let dataComponent = "data"
    fileprivate static let apiVersionComponent = "2.5"
    fileprivate static let weatherComponent = "weather"
    fileprivate static let cityStateQueryName = "q"
    fileprivate static let zipQueryName = "zip"
    fileprivate static let unitsQueryName = "units"
    fileprivate static let unitsQueryValue = "imperial"
    fileprivate static let apiKeyQueryName = "appid"
    fileprivate static let apiKeyValue = "da65fafb6cb9242168b7724fb5ab75e7"
    fileprivate static let iconImageComponent = "img"
    fileprivate static let weatherImageComponent = "w"
    fileprivate static let iconImageExtension = "png"
}

class WeatherController {
    
    // MARK: - Fetch Functions
    
    /**
     This function fetches the `TopLevelWeatherDicts` using an array of `SearchObject`
     ### This function is used for fetching the saved searchObjects at launch
     - Parameter searchableObjects: An array of `SearchObject` to be looped through and used in a fetch from the API
     - Parameter completion: Completes with either an array of `TopLevelWeatherDict` or a `WeatherError`
     */
    static func fetchWithSearchableObjects(searchableObjects: [SearchObject], completion: @escaping (Result<[TopLevelWeatherDict], WeatherError>) -> Void) {
        var returnedWeatherDicts: [TopLevelWeatherDict] = []
        let dispatchGroup = DispatchGroup()
        for object in searchableObjects {
            if let zipCode = object.zip {
                dispatchGroup.enter()
                fetchWeatherBy(zipCode: zipCode) { (result) in
                    switch result {
                    case .success(var weatherDict):
                        weatherDict.searchObject = object
                        returnedWeatherDicts.append(weatherDict)
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                    dispatchGroup.leave()
                }
            } else if let city = object.city, let state = object.state {
                dispatchGroup.enter()
                fetchWeatherBy(city: city, andState: state) { (result) in
                   switch result {
                    case .success(var weatherDict):
                        weatherDict.searchObject = object
                        returnedWeatherDicts.append(weatherDict)
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            if returnedWeatherDicts.isEmpty {
                return completion(.failure(.noData))
            }
            return completion(.success(returnedWeatherDicts))
        }
    }
    
    /**
    This function fetches the `TopLevelWeatherDict` using a single`SearchObject`
    ### This function is used for fetching a newly created searchObject
    - Parameter searchObject: A `SearchObject` used in a fetch from the API
    - Parameter completion: Completes with either a`TopLevelWeatherDict` or a `WeatherError`
    */
    static func fetchWithSingleSearchObject(searchObject: SearchObject, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        if let zipCode = searchObject.zip {
            fetchWeatherBy(zipCode: zipCode) { (result) in
                switch result {
                case .success(var weatherDict):
                    weatherDict.searchObject = searchObject
                    return completion(.success(weatherDict))
                case .failure(let error):
                    print(error.errorDescription)
                    SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: searchObject)
                    return completion(.failure(.dataTaskError(error)))
                }
            }
        } else if let city = searchObject.city, let state = searchObject.state {
            fetchWeatherBy(city: city, andState: state) { (result) in
               switch result {
                case .success(var weatherDict):
                    weatherDict.searchObject = searchObject
                    return completion(.success(weatherDict))
               case .failure(let error):
                    print(error.errorDescription)
                    SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: searchObject)
                    return completion(.failure(.dataTaskError(error)))
                }
            }
        }
    }
    
    /**
    This function fetches the `TopLevelWeatherDicts` using a city and state `String` value
    - Parameter city: A `String` added to the URL constructed for the API call
    - Parameter state: A `String` added to the URL constructed for the API call
    - Parameter completion: Completes with either a`TopLevelWeatherDict` or a `WeatherError`
    */
    static func fetchWeatherBy(city: String, andState state: String, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        guard var baseURL = URL(string: WeatherConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        baseURL.appendPathComponent(WeatherConstants.dataComponent)
        baseURL.appendPathComponent(WeatherConstants.apiVersionComponent)
        baseURL.appendPathComponent(WeatherConstants.weatherComponent)
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let cityStateQuery = URLQueryItem(name: WeatherConstants.cityStateQueryName, value: "\(city),\(state)")
        let unitsQuery = URLQueryItem(name: WeatherConstants.unitsQueryName, value: WeatherConstants.unitsQueryValue)
        let apiKeyQuery = URLQueryItem(name: WeatherConstants.apiKeyQueryName, value: WeatherConstants.apiKeyValue)
        urlComponents?.queryItems = [cityStateQuery, unitsQuery, apiKeyQuery]
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        
        WeatherAPIService.fetchWeatherWith(url: finalURL) { (result) in
            return completion(result)
        }
    }
    
    /**
    This function fetches the `TopLevelWeatherDicts` using a zipCode `Int` value
    - Parameter zipCode: An `Int` added to the URL constructed for the API call
    - Parameter completion: Completes with either a`TopLevelWeatherDict` or a `WeatherError`
    */
    static func fetchWeatherBy(zipCode: Int, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        guard var baseURL = URL(string: WeatherConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        baseURL.appendPathComponent(WeatherConstants.dataComponent)
        baseURL.appendPathComponent(WeatherConstants.apiVersionComponent)
        baseURL.appendPathComponent(WeatherConstants.weatherComponent)
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let zipCodeQuery = URLQueryItem(name: WeatherConstants.zipQueryName, value: String(zipCode))
        let unitsQuery = URLQueryItem(name: WeatherConstants.unitsQueryName, value: WeatherConstants.unitsQueryValue)
        let apiKeyQuery = URLQueryItem(name: WeatherConstants.apiKeyQueryName, value: WeatherConstants.apiKeyValue)
        urlComponents?.queryItems = [zipCodeQuery, unitsQuery, apiKeyQuery]
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        
        WeatherAPIService.fetchWeatherWith(url: finalURL) { (result) in
            return completion(result)
        }
    }
    
    /**
    This function fetches the `UIImage` using an iconCode `String` value
    - Parameter iconCode: A `String` added to the URL constructed for the API call
    - Parameter completion: Completes with either a`TopLevelWeatherDict` or a `WeatherError`
    */
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
