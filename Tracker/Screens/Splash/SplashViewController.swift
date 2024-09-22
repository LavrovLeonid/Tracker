//
//  SplashViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let onboardingService = OnboardingService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onboardingService.isComplete {
            presentMainTabBar()
        } else {
            presentOnboarding()
        }
    }
    
    private func presentMainTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let trackersViewController = TrackersViewController(
            viewModel: TrackersViewModel(
                dataStore: TrackersDataStore()
            )
        )
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackersTitle", comment: "Trackers title"),
            image: .trackersIcon,
            tag: 0
        )
        
        let statisticsViewController = StatisticsViewController(
            viewModel: StatisticsViewModel(
                statisticsDataStore: StatisticsDataStore(),
                statisticsModel: StatisticsModel())
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statisticsTitle", comment: "Statistics title"),
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
    
    private func presentOnboarding() {
        let onboardingViewController = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        onboardingViewController.configure(delegate: self)
        onboardingViewController.modalPresentationStyle = .fullScreen
        
        present(onboardingViewController, animated: true)
    }
}

extension SplashViewController: OnboardingViewControllerDelegate {
    func onboardingDidComplete(_ viewController: OnboardingViewControllerProtocol) {
        onboardingService.complete()
        
        presentMainTabBar()
    }
}
