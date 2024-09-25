//
//  StatisticsDataStoreProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/19/24.
//

import Foundation

protocol StatisticsDataStoreProtocol {
    var isEmptyStatistic: Bool { get }
    var delegate: StatisticsDataStoreDelegate? { get set }
    
    func fetchStatistic() -> [StatisticType]
}
