//
//  TrackersFilter.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/17/24.
//

import Foundation

enum TrackersFilter: CaseIterable {
    case all
    case today
    case completed
    case notCompleted
    
    var title: String {
        switch self {
            case .all:
                "Все трекеры"
            case .today:
                "Трекеры на сегодня"
            case .completed:
                "Завершенные"
            case .notCompleted:
                "Не завершенные"
        }
    }
}
