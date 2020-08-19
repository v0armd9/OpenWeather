//
//  SearchableObjectController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

class SearchableObjectController {
    
    static let sharedInstance = SearchableObjectController()
    
    var searchableObjects: [SearchObject] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    @discardableResult
    func createSearchableObjectWith(city: String?, andState state: String?, orZip zip: Int?) -> SearchObject {
        let newSearchObject = SearchObject(city: city, state: state, zip: zip)
        searchableObjects.append(newSearchObject)
        saveToPersistentStore()
        return newSearchObject
    }
    
    func deleteSearchableObject(searchObject: SearchObject) {
        if let index = searchableObjects.firstIndex(of: searchObject) {
            self.searchableObjects.remove(at: index)
        }
        saveToPersistentStore()
    }
    
    func fileURL() -> URL {
        
        //Get the array of paths
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //specify the first path
        let fullURL = paths[0].appendingPathComponent("searchObjects.json")
      
        return fullURL
    }
    
    //Save the data at that URL.
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(searchableObjects)
            try data.write(to: fileURL())
        } catch let error {
            print(error)
        }
    }
    
    //Fetch the data from that URL.
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
