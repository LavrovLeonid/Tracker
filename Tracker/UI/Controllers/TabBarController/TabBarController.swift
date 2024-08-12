//
//  TabBarController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        tabBar.backgroundColor = .trackerWhite
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        tabBar.clipsToBounds = true
    }
}
