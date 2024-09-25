//
//  StatisticType.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/19/24.
//

import Foundation

enum StatisticType {
    case bestPeriod(Int)
    case perfectDays(Int)
    case completedTrackers(Int)
    case averageValue(Int)
    
    var count: Int {
        switch self {
            case .bestPeriod(let count):
                count
            case .perfectDays(let count):
                count
            case .completedTrackers(let count):
                count
            case .averageValue(let count):
                count
        }
    }
    
    var description: String {
        switch self {
            case .bestPeriod:
                "Лучший период"
            case .perfectDays:
                "Идеальные дни"
            case .completedTrackers:
                "Трекеров завершено"
            case .averageValue:
                "Среднее значение"
        }
    }
}
