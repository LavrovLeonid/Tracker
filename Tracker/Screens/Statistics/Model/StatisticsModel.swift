//
//  StatisticsModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/21/24.
//

import Foundation

final class StatisticsModel: StatisticsModelProtocol {
    var statistics: [StatisticType] = []
    
    func setStatistics(_ statistics: [StatisticType]) {
        self.statistics = statistics
    }
}
