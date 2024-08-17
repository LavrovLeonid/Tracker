//
//  SplashViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentMainTabBar()
    }
    
    private func presentMainTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: .trackersIcon,
            tag: 0
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: .statisticsIcon,
            tag: 1
        )
        
        let mainTabBar = TabBarController()
        
        mainTabBar.viewControllers = [
            NavigationController(rootViewController: trackersViewController), 
            NavigationController(rootViewController: statisticsViewController)
        ]
        
        window.rootViewController = mainTabBar
    }
}
