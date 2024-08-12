//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(image: .emptyStatistics, text: "Анализировать пока нечего")
        
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .trackerWhite
        
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Статистика"
    }
}
