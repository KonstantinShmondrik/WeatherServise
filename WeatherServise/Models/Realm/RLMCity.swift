//
//  RLMCity.swift
//  WeatherServise
//
//  Created by Константин Шмондрик on 17.03.2022.
//

import Foundation
import RealmSwift

class RLMCity: Object {
    @objc dynamic var name = ""
    let weathers = List<RLMWeather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
