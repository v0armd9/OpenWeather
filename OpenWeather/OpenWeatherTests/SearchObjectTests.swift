//
//  SearchObjectTests.swift
//  OpenWeatherTests
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import XCTest
@testable import OpenWeather

class SearchObjectTests: XCTestCase {
    
    func testCreateSearchableObject() {
        let countBefore = SearchableObjectController.sharedInstance.searchableObjects.count
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "Midvale", andState: "Utah", orZip: nil)
        let countAfter = SearchableObjectController.sharedInstance.searchableObjects.count
        XCTAssertEqual(newObjectCity.city, "Midvale")
        XCTAssertEqual(newObjectCity.state, "Utah")
        XCTAssertNil(newObjectCity.zip)
        XCTAssertNotEqual(countBefore, countAfter)
        XCTAssertEqual(countBefore + 1, countAfter)
        let newObjectZip = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: nil, andState: nil, orZip: 84047)
        let countAfterSecond = SearchableObjectController.sharedInstance.searchableObjects.count
        XCTAssertNil(newObjectZip.city)
        XCTAssertNil(newObjectZip.state)
        XCTAssertEqual(newObjectZip.zip, 84047)
        XCTAssertNotEqual(countBefore, countAfterSecond)
        XCTAssertEqual(countAfter + 1, countAfterSecond)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectCity)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectZip)
    }
    
    func testDeleteSearchableObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "MadeUpCity", andState: "MadeUpState", orZip: nil)
        let countBefore = SearchableObjectController.sharedInstance.searchableObjects.count
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectCity)
        let countAfter = SearchableObjectController.sharedInstance.searchableObjects.count
        XCTAssertNil(SearchableObjectController.sharedInstance.searchableObjects.firstIndex(of: newObjectCity))
        XCTAssertNotEqual(countBefore, countAfter)
        XCTAssertEqual(countBefore - 1, countAfter)
    }
    
    func testSuccessfulSearchWithSingleObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "Midvale", andState: "Utah", orZip: nil)
        var weatherDict: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        let expectation = self.expectation(description: "Search")
        WeatherController.fetchWithSingleSearchObject(searchObject: newObjectCity) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDict = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(weatherDict)
        XCTAssertEqual(weatherDict?.name, "Midvale")
        XCTAssertNil(error)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectCity)
    }
    
    func testFailedSearchWithSingleObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "MadeUpName", andState: "Utah", orZip: nil)
        var weatherDict: TopLevelWeatherDict? = nil
        var error: WeatherError? = nil
        let expectation = self.expectation(description: "Search")
        WeatherController.fetchWithSingleSearchObject(searchObject: newObjectCity) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDict = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(error)
        XCTAssertNil(weatherDict)
    }
    
    func testSuccessfulSearchWithArrayObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "Midvale", andState: "Utah", orZip: nil)
        let newObjectZip = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: nil, andState: nil, orZip: 84041)
        var weatherDictArray: [TopLevelWeatherDict]? = nil
        var error: WeatherError? = nil
        let expectation = self.expectation(description: "Search")
        WeatherController.fetchWithSearchableObjects(searchableObjects: [newObjectCity, newObjectZip]) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDictArray = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(weatherDictArray)
        XCTAssertEqual(weatherDictArray?.count, 2)
        XCTAssertNil(error)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectCity)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectZip)
    }
    
    func testPartialFailedSearchWithArrayObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "MadeUpName", andState: "Utah", orZip: nil)
        let newObjectZip = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: nil, andState: nil, orZip: 84041)
        var weatherDictArray: [TopLevelWeatherDict]? = nil
        var error: WeatherError? = nil
        let expectation = self.expectation(description: "Search")
        WeatherController.fetchWithSearchableObjects(searchableObjects: [newObjectCity, newObjectZip]) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDictArray = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(weatherDictArray)
        XCTAssertEqual(weatherDictArray?.count, 1)
        XCTAssertNil(error)
        SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: newObjectZip)
    }
    
    func testFailedSearchWithArrayObject() {
        let newObjectCity = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: "MadeUpName", andState: "Utah", orZip: nil)
        let newObjectZip = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: nil, andState: nil, orZip: 840410765)
        var weatherDictArray: [TopLevelWeatherDict]? = nil
        var error: WeatherError? = nil
        let expectation = self.expectation(description: "Search")
        WeatherController.fetchWithSearchableObjects(searchableObjects: [newObjectCity, newObjectZip]) { (result) in
            switch result {
            case .success(let retrievedWeatherDict):
                weatherDictArray = retrievedWeatherDict
                expectation.fulfill()
            case .failure(let retrievedError):
                error = retrievedError
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(error)
        XCTAssertNil(weatherDictArray)
    }
}
