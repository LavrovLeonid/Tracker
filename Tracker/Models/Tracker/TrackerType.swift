//
//  TrackerType.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/4/24.
//

import Foundation

enum TrackerType {
    case habit
    case event
    
    var text: String {
        switch self {
            case .habit:
                "Привычка"
            case .event:
                "Нерегулярное событие"
        }
    }
    
    var title: String {
        switch self {
            case .habit:
                "Новая привычка"
            case .event:
                "Новое нерегулярное событие"
        }
    }
}
