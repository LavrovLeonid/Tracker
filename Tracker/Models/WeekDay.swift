//
//  WeekDay.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday = 1
    
    var title: String {
        switch self {
            case .monday:
                "Понедельник"
            case .tuesday:
                "Вторник"
            case .wednesday:
                "Среда"
            case .thursday:
                "Четверг"
            case .friday:
                "Пятница"
            case .saturday:
                "Суббота"
            case .sunday:
                "Воскресенье"
        }
    }
    
    var short: String {
        switch self {
            case .monday:
                "Пн"
            case .tuesday:
                "Вт"
            case .wednesday:
                "Ср"
            case .thursday:
                "Чт"
            case .friday:
                "Пт"
            case .saturday:
                "Сб"
            case .sunday:
                "Вс"
        }
    }
    
    static func getSorted(by set: Set<WeekDay>) -> [WeekDay] {
        Self.allCases.reduce([]) { partialResult, weekDay in
            if set.contains(weekDay) {
                return partialResult + [weekDay]
            }
            
            return partialResult
        }
    }
}
