//
//  ListItemCollectionCellPlacement.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/7/24.
//

import Foundation

enum ListItemCollectionCellPlacement {
    case top
    case bottom
    case middle
    case alone
    
    static func getPlacement(at index: Int, in count: Int) -> ListItemCollectionCellPlacement {
        guard count != 1 else { return .alone }
        
        switch index {
            case 0:
                return .top
            case count - 1:
                return .bottom
            default:
                return .middle
        }
    }
}
