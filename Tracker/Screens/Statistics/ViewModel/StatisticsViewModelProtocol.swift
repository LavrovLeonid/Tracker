//
//  StatisticsViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/19/24.
//

import Foundation

protocol StatisticsViewModelProtocol {
    var onStatisticsPresentEmptyView: BindingWithoutValue? { get set }
    var onStatisticsPresentCollectionView: BindingWithoutValue? { get set }
    var onStatisticsReloadCollectionView: BindingWithoutValue? { get set }
    
    func viewDidLoad()
    
    func numberOfItemsInSection(_ section: Int) -> Int
    func statistic(at indexPath: IndexPath) -> StatisticType
}
