//
//  SearchObject.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import Foundation

struct SearchObject: Codable, Equatable {
    let city: String?
    let state: String?
    let zip: Int?
}
