//
//  Day.swift
//  WeatherServise
//
//  Created by Константин Шмондрик on 17.03.2022.
//

import Foundation

enum Day: Int, CaseIterable {
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var title: String {
        switch self {
        case .monday: return "ПН"
        case .tuesday: return "ВТ"
        case .wednesday: return "СР"
        case .thursday: return "ЧТ"
        case .friday: return "ПТ"
        case .saturday: return "СБ"
        case .sunday: return "ВС"
        }
    }
    
    var isWeekend: Bool {
        switch self {
        case .monday, .tuesday, .wednesday, .thursday, .friday:
            return false
        case .saturday, .sunday:
            return true
        }
    }
}
