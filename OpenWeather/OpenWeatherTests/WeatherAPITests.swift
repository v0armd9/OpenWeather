//
//  WeatherAPITests.swift
//  OpenWeatherTests
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import XCTest
@testable import OpenWeather

class WeatherAPITests: XCTestCase {
    
    func testValidURL() throws {
        let url = try XCTUnwrap(URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Midvale,Utah&units=imperial&appid=da65fafb6cb9242168b7724fb5ab75e7"))
        let expectation = self.expectation(description: "Fetch")
        var name = ""
        WeatherAPIService.fetchWeatherWith(url: url) { (result) in
            switch result {
            case .success(let weatherDict):
                name = weatherDict.name!
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(name, "Midvale")
    }
    
    func testUnsupportedURL() throws {
        let url = try XCTUnwrap(URL(string: "api.openweathermap.org/data/2.5/weather?q=Midvale,Utah&units=imperial&appid=da65fafb6cb9242168b7724fb5ab75e7"))
        let expectation = self.expectation(description: "Error")
        var error: WeatherError? = nil
        var weatherDict: TopLevelWeatherDict? = nil
        WeatherAPIService.fetchWeatherWith(url: url) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDict = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let returnedError):
                error = returnedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(error)
        XCTAssertNil(weatherDict)
    }
    
    func testValidImage() throws {
        let url = try XCTUnwrap(URL(string: "https://openweathermap.org/img/w/03n.png"))
        let expectation = self.expectation(description: "ImageFetch")
        var image: UIImage? = nil
        var error: WeatherError? = nil
        WeatherAPIService.fetchIconImageWith(url: url) { (result) in
            switch result {
            case .success(let retrievedImage):
                image = retrievedImage
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(image)
        XCTAssertNil(error)
    }
    
    func testNoImage() throws {
        let url = try XCTUnwrap(URL(string: "https://openweathermap.org/img/w/O3n.png"))
        let expectation = self.expectation(description: "ImageFetch")
        var image: UIImage? = nil
        var error: WeatherError? = nil
        WeatherAPIService.fetchIconImageWith(url: url) { (result) in
            switch result {
            case .success(let retrievedImage):
                image = retrievedImage
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(error)
        XCTAssertNil(image)
    }
}
