//
//  TrackerColor.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/28/24.
//

import UIKit

enum TrackerColor: CaseIterable {
    case selection1
    case selection2
    case selection3
    case selection4
    case selection5
    case selection6
    case selection7
    case selection8
    case selection9
    case selection10
    case selection11
    case selection12
    case selection13
    case selection14
    case selection15
    case selection16
    case selection17
    case selection18
    
    var uiColor: UIColor {
        switch self {
            case .selection1:
                    .trackerColorSelection1
            case .selection2:
                    .trackerColorSelection2
            case .selection3:
                    .trackerColorSelection3
            case .selection4:
                    .trackerColorSelection4
            case .selection5:
                    .trackerColorSelection5
            case .selection6:
                    .trackerColorSelection6
            case .selection7:
                    .trackerColorSelection7
            case .selection8:
                    .trackerColorSelection8
            case .selection9:
                    .trackerColorSelection9
            case .selection10:
                    .trackerColorSelection10
            case .selection11:
                    .trackerColorSelection11
            case .selection12:
                    .trackerColorSelection12
            case .selection13:
                    .trackerColorSelection13
            case .selection14:
                    .trackerColorSelection14
            case .selection15:
                    .trackerColorSelection15
            case .selection16:
                    .trackerColorSelection16
            case .selection17:
                    .trackerColorSelection17
            case .selection18:
                    .trackerColorSelection18
        }
    }
}
