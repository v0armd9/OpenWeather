//
//  WeatherControllerTests.swift
//  OpenWeatherTests
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import XCTest

@testable import OpenWeather

class WeatherControllerTests: XCTestCase {
    
    func testValidCityStateSearch() {
        
        let expectation = self.expectation(description: "fetch")
        var weatherObject: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        WeatherController.fetchWeatherBy(city: "Midvale", andState: "Utah") { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherObject = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(weatherObject)
        
    }
    
    func testInvalidCityStateSearch() {
        let expectation = self.expectation(description: "fetchCityState")
        var weatherObject: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        WeatherController.fetchWeatherBy(city: "Mooselookmeguntic", andState: "Maine") { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherObject = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(weatherObject)
        XCTAssertNotNil(error)
    }
    
    func testValidZipSearch() {
        let expectation = self.expectation(description: "fetchZip")
        var weatherObject: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        WeatherController.fetchWeatherBy(zipCode: 84047) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherObject = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(weatherObject)
    }
    
    func testInvalidZipSearch() {
        let expectation = self.expectation(description: "fetchZip")
        var weatherObject: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        WeatherController.fetchWeatherBy(zipCode: 84047000000) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherObject = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(weatherObject)
        XCTAssertNotNil(error)
    }
    
    func testFetchImageSuccess() {
        
        let expectation = self.expectation(description: "fetchImage")
        var image: UIImage? = nil
        var error: WeatherError? = nil
        
        WeatherController.fetchWeatherIcon(iconCode: "03n") { (result) in
            switch result {
            case .success(let retrievedImage):
                image = retrievedImage
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(image)
    }
    
    func testFetchImageFailure() {
        
        let expectation = self.expectation(description: "fetchImage")
        var image: UIImage? = nil
        var error: WeatherError? = nil
        
        WeatherController.fetchWeatherIcon(iconCode: "O3n") { (result) in
            switch result {
            case .success(let retrievedImage):
                image = retrievedImage
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(image)
        XCTAssertNotNil(error)
    }
    
    func testImageFetchFromWeatherItem() throws {
        let expectation = self.expectation(description: "fetchImage")
        var image: UIImage? = nil
        var error: WeatherError? = nil
        
        WeatherController.fetchWeatherBy(zipCode: 84047) { (result) in
            switch result {
            case .success(let weatherDict):
                guard let iconCode = weatherDict.weather.first?.icon else { XCTAssertNotNil(weatherDict.weather.first?.icon); return }
                WeatherController.fetchWeatherIcon(iconCode: iconCode) { (result) in
                    switch result {
                    case .success(let retrievedImage):
                        image = retrievedImage
                        expectation.fulfill()
                    case .failure(let retrievedError):
                        error = retrievedError
                        expectation.fulfill()
                    }
                }
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error)
        XCTAssertNotNil(image)
    }
}
