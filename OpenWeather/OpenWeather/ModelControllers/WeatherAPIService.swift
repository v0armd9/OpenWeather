//
//  WeatherAPIService.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation
import UIKit

class WeatherAPIService {
    
    /**
     This function calls the OpenWeatherAPI to retrieve JSON and decode it into a `TopLevelWeatherDict`.
     
     ### The function will either complete with a TopLevelWeatherDict or a WeatherError.
     - Parameter url: A `URL` constructed in the WeatherController fetch functions
     - Parameter completion: Completes with either a `TopLevelWeatherDict` or a `WeatherError`.
     */
    static func fetchWeatherWith(url: URL, completion: @escaping (Result<TopLevelWeatherDict, WeatherError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let error = error {
                return completion(.failure(.dataTaskError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let weatherDict = try JSONDecoder().decode(TopLevelWeatherDict.self, from: data)
                return completion(.success(weatherDict))
            } catch {
                return completion(.failure(.jsonDecodeError(error)))
            }
        }.resume()
    }
    
    /**
     This function retrieves an iconImage based on a code passed into the url from the WeatherController's fetchWeatherIcon function
     ### The function will either complete with a UIImage or a WeatherError
     - Parameter url: A `URL` contructed in the WeatherController fetchWeatherIcon function
     - Parameter completion: Completes with either a `UIImage` or a `WeatherError`.
     */
    static func fetchIconImageWith(url: URL, completion: @escaping (Result<UIImage, WeatherError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let error = error {
                return completion(.failure(.dataTaskError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let retrievedImage = UIImage(data: data) else { return completion(.failure(.imageDecodeError)) }
            return completion(.success(retrievedImage))
        }.resume()
    }
}
