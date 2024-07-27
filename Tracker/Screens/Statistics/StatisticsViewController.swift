//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .trackerWhite
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Статистика"
    }
}
