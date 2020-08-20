//
//  AppDelegate.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/18/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "FirstLaunch") == true {
            defaults.set(true, forKey: "FirstLaunch")
        } else {
            let searchObjectArray = [
                (city: "Salt Lake City", state: "Utah"),
                (city: "New York", state: "New York"),
                (city: "San Francisco", state: "California")
            ]
            for object in searchObjectArray {
                SearchableObjectController.sharedInstance.createSearchableObjectWith(city: object.city, andState: object.state, orZip: nil)
            }
            defaults.set(true, forKey: "FirstLaunch")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

