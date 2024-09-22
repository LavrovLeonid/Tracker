//
//  StatisticsModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/21/24.
//

import Foundation

protocol StatisticsModelProtocol {
    var statistics: [StatisticType] { get }
    
    func setStatistics(_ statistics: [StatisticType])
}
