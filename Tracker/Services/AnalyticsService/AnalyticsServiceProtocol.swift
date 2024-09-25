//
//  AnalyticsServiceProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/22/24.
//

import Foundation

protocol AnalyticsServiceProtocol {
    func activate()
    func report(_ event: AnalyticEvent, from screen: Screen)
}
