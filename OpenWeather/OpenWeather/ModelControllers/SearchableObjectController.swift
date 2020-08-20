//
//  SearchableObjectController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

class SearchableObjectController {
    
    // MARK: - Shared Instance
    static let sharedInstance = SearchableObjectController()
    
    // search objects created by the user
    var searchableObjects: [SearchObject] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD Functions
    /**
     This function creates a searchObject, appends it to the searchableObjects array on the sharedInstance and calls saveToPersistentStore. The result of this function is discardable.
     ### There will only ever be a city and state passed in or a zipCode, never all three.
     - Parameter city: A city name represented by a `String` value
     - Parameter state: A state name represented by a `String` value
     - Parameter zip: A zip code represented by an `Int` value
     
     - Returns: A `SearchObject` created from the passed in parameters
     */
    @discardableResult
    func createSearchableObjectWith(city: String?, andState state: String?, orZip zip: Int?) -> SearchObject {
        let newSearchObject = SearchObject(city: city, state: state, zip: zip)
        searchableObjects.append(newSearchObject)
        saveToPersistentStore()
        return newSearchObject
    }
    
    /**
     This function removes the passed in search object from the searchableObjects array on the SearchableObjectController.sharedInstance
     - Parameter searchObject: The `SearchObject` to be removed
     */
    func deleteSearchableObject(searchObject: SearchObject) {
        if let index = searchableObjects.firstIndex(of: searchObject) {
            self.searchableObjects.remove(at: index)
        }
        saveToPersistentStore()
    }
    
    /**
     This function creates a fileURL to save the users searchObjects at in JSON format
     - Returns: A `URL` to be used in the save and load functions.
     */
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fullURL = paths[0].appendingPathComponent("searchObjects.json")
      
        return fullURL
    }
    
    /**
     This function saves the searchableObjects array as JSON at the provided URL.
     */
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(searchableObjects)
            try data.write(to: fileURL())
        } catch let error {
            print(error)
        }
    }
    
    /**
     This function loads and decodes the JSON file into an array of `SearchObjects` and assigns that array to the searchableObjects array on the sharedInstance.
     */
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let searchableObjects = try decoder.decode([SearchObject].self, from: data)
            self.searchableObjects = searchableObjects
        } catch let error {
            print(error)
        }
    }
}
