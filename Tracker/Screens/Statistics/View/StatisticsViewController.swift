//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class StatisticsViewController: UIViewController, PresentingViewController, BindableViewController {
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(image: .emptyStatistics, text: "Анализировать пока нечего")
        
        return emptyView
    }()
    private lazy var statisticsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            StatisticsCell.self,
            forCellWithReuseIdentifier: StatisticsCell.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    var viewModel: StatisticsViewModelProtocol
    
    func bind() {
        viewModel.onStatisticsPresentEmptyView = { [weak self] in
            guard let self else { return }
            
            presentEmptyView()
        }
        
        viewModel.onStatisticsPresentCollectionView = { [weak self] in
            guard let self else { return }
            
            presentStatistics()
        }
        
        viewModel.onStatisticsReloadCollectionView = { [weak self] in
            guard let self else { return }
            
            statisticsCollectionView.reloadData()
        }
    }
    
    typealias ViewModel = StatisticsViewModelProtocol
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
        
        viewModel.viewDidLoad()
    }
    
    func setupView() {
        navigationItem.title = "Статистика"
        navigationItem.largeTitleDisplayMode = .always
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.isHidden = true
        
        navigationItem.searchController = searchController
        
        view.backgroundColor = .trackerWhite
    }
    
    func setupSubviews() {
        view.addSubview(emptyView)
        view.addSubview(statisticsCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            statisticsCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            statisticsCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            statisticsCollectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            statisticsCollectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func presentStatistics() {
        statisticsCollectionView.isHidden = false
        emptyView.isHidden = true
    }
    
    func presentEmptyView() {
        statisticsCollectionView.isHidden = true
        emptyView.isHidden = false
    }
}

extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StatisticsCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? StatisticsCell {
            cell.configure(with: viewModel.statistic(at: indexPath))
        }
        
        return cell
    }
}

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
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
        CGSize(width: collectionView.frame.width - 32, height: 90)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
}
