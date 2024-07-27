//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class TrackersViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .trackerWhite
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Трекеры"
        
        let leftBarButtonItem = UIBarButtonItem(
            image: .plusIcon,
            style: .plain,
            target: nil,
            action: nil
        )
        leftBarButtonItem.tintColor = .trackerBlack
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
        navigationItem.searchController = searchController
    }
}
