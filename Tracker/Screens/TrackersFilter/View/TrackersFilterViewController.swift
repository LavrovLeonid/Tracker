//
//  TrackersFilterViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/17/24.
//

import UIKit

final class TrackersFilterViewController: UIViewController, PresentingViewController, TrackersFilterViewControllerProtocol {
    private let filters = TrackersFilter.allCases
    private var appliedFilter = TrackersFilter.all
    
    private weak var delegate: TrackersFilterViewControllerDelegate?
    
    private lazy var filtersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            ListItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    func configure(appliedFilter: TrackersFilter, delegate: TrackersFilterViewControllerDelegate) {
        self.appliedFilter = appliedFilter
        self.delegate = delegate
    }
    
    func setupView() {
        title = "Фильтры"
        
        view.backgroundColor = .trackerWhite
    }
    
    func setupSubviews() {
        view.addSubview(filtersCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filtersCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            filtersCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            filtersCollectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            filtersCollectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
        
    }
}

extension TrackersFilterViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        filters.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? ListItemCollectionViewCell {
            let filter = filters[indexPath.item]
            
            cell.configure(
                placement: .getPlacement(
                    at: indexPath.item,
                    in: filters.count
                )
            )
            cell.configure(title: filter.title)
            cell.configure(endAdorment: filter == appliedFilter ? .check : .none)
        }
        
        return cell
    }
}

extension TrackersFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 16, bottom: 0,right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: 75)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        delegate?.applyFilter(self, filter: filters[indexPath.item])
    }
}

