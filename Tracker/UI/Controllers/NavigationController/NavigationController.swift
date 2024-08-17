//
//  NavigationController.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/3/24.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        navigationBar.prefersLargeTitles = true
    }
}
