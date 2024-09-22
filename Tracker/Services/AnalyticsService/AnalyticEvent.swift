//
//  AnalyticEvent.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/22/24.
//

import Foundation

enum AnalyticEvent {
    case open
    case close
    case click(AnalyticItem)
    
    var name: String {
        switch self {
            case .open:
                "open"
            case .close:
                "close"
            case .click:
                "click"
        }
    }
}
