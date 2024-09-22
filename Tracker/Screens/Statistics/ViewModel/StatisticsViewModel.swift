//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/19/24.
//

import Foundation

final class StatisticsViewModel: StatisticsViewModelProtocol {
    // MARK: Model
    private var statisticsDataStore: StatisticsDataStoreProtocol
    private let statisticsModel: StatisticsModelProtocol
    
    // MARK: Bindings
    var onStatisticsPresentEmptyView: BindingWithoutValue?
    var onStatisticsPresentCollectionView: BindingWithoutValue?
    var onStatisticsReloadCollectionView: BindingWithoutValue?
    
    // MARK: Initialization
    init(
        statisticsDataStore: StatisticsDataStoreProtocol,
        statisticsModel: StatisticsModelProtocol
    ) {
        self.statisticsDataStore = statisticsDataStore
        self.statisticsModel = statisticsModel
    }
    
    // MARK: Methods
    func viewDidLoad() {
        statisticsDataStore.delegate = self
        
        updateStatistics()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        statisticsModel.statistics.count
    }
    
    func statistic(at indexPath: IndexPath) -> StatisticType {
        statisticsModel.statistics[indexPath.item]
    }
    
    private func updateStatistics() {
        let statistics = statisticsDataStore.fetchStatistic()
        
        statisticsModel.setStatistics(statisticsDataStore.fetchStatistic())
        
        if statistics.isEmpty {
            onStatisticsPresentEmptyView?()
        } else {
            onStatisticsPresentCollectionView?()
        }
        
        onStatisticsReloadCollectionView?()
    }
}

extension StatisticsViewModel: StatisticsDataStoreDelegate {
    func didUpdate() {
        updateStatistics()
    }
}
