//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        let trackersViewController = TrackersViewController()
        let trackersTabBarItem = UITabBarItem(
            title: "Трекеры",
            image: .trackersIcon,
            tag: 0
        )
        trackersViewController.tabBarItem = trackersTabBarItem
        
        let statisticsViewController = StatisticsViewController()
        let statisticsTabBarItem = UITabBarItem(
            title: "Статистика",
            image: .statisticsIcon,
            tag: 1
        )
        statisticsViewController.tabBarItem = statisticsTabBarItem
        
        tabBar.backgroundColor = .trackerWhite
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        tabBar.clipsToBounds = true
        
        let trackersNavigationController = UINavigationController(
            rootViewController: trackersViewController
        )
        trackersNavigationController.navigationBar.prefersLargeTitles = true
        
        let statisticsNavigationController = UINavigationController(
            rootViewController: statisticsViewController
        )
        statisticsNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
}
