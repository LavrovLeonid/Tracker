//
//  TrackerFormViewControllerListItems.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/9/24.
//

import Foundation

enum TrackerFormViewControllerListItems: Int, CaseIterable {
    case categories
    case schedule
    
    var title: String {
        switch self {
            case .categories:
                "Категория"
            case .schedule:
                "Расписание"
        }
    }
}
