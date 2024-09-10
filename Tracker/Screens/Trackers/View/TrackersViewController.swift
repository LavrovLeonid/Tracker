//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class TrackersViewController:
    UIViewController, PresentingViewController, BindableViewController {
    // MARK: Views
    private let trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            DefaultHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DefaultHeaderReusableView.reuseIdentifier
        )
        
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(image: .emptyTrackers, text: "Что будем отслеживать?")
        
        return emptyView
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .trackerBlue
        datePicker.locale = Calendar.current.locale
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    // MARK: Helpers
    private let geometricParams = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    // MARK: BindableViewController
    typealias ViewModel = TrackersViewModelProtocol
    private(set) var viewModel: ViewModel?
    
    func initialize(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        bind()
    }
    
    func bind() {
        viewModel?.onTrackersStateChange = { [weak self] isEmptyTrackerCateogries in
            guard let self else { return }
            
            if isEmptyTrackerCateogries {
                presentEmptyView()
            } else {
                presentTrackersCollectionView()
                trackersCollectionView.reloadData()
            }
        }
    }
    
    // MARK: Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
        
        viewModel?.viewDidLoad()
    }
    
    // MARK: PresentingViewController
    func setupView() {
        navigationItem.title = "Трекеры"
        
        let leftBarButtonItem = UIBarButtonItem(
            image: .plusIcon,
            style: .plain,
            target: self,
            action: #selector(addTrackerCategoryTapped)
        )
        leftBarButtonItem.tintColor = .trackerBlack
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.backgroundColor = .trackerWhite
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
    }
    
    func setupSubviews() {
        view.addSubview(emptyView)
        view.addSubview(trackersCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            emptyView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            emptyView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: 77)
        ])
    }
    
    // MARK: Methods
    private func presentEmptyView() {
        trackersCollectionView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func presentTrackersCollectionView() {
        trackersCollectionView.isHidden = false
        emptyView.isHidden = true
        
        trackersCollectionView.reloadData()
    }
    
    private func presentCreateTrackerCategoryViewController() {
        let createTrackerViewController = CreateTrackerViewController()
        
        createTrackerViewController.configure(with: self)
        
        present(
            UINavigationController(rootViewController: createTrackerViewController),
            animated: true
        )
    }
    
    private func presentTrackerFormViewController(
        with tracker: Tracker,
        at category: TrackerCategory
    ) {
        let trackerFormViewController = TrackerFormViewController()
        
        present(
            UINavigationController(rootViewController: trackerFormViewController),
            animated: true
        )
    }
    
    private func presentAlertToRemoveTracker(at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(
            UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.viewModel?.removeTracker(at: indexPath)
            }
        )
        alertController.addAction(
            UIAlertAction(title: "Отменить", style: .cancel)
        )
        
        present(alertController, animated: true)
    }
    
    // MARK: Actions
    @IBAction private func addTrackerCategoryTapped() {
        presentCreateTrackerCategoryViewController()
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel?.setCurrentDate(sender.date)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.numberOfSections ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.numberOfItemsInSection(section) ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DefaultHeaderReusableView.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? DefaultHeaderReusableView {
            cell.configure(with: viewModel?.category(at: indexPath.section).name ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? TrackerCollectionViewCell,
           let viewModel {
            let tracker = viewModel.tracker(at: indexPath)
            
            cell.setupCell(
                with: tracker,
                quantity: viewModel.countTrackerRecords(for: tracker),
                isSelected: viewModel.isSelectedTracker(at: tracker),
                delegate: self
            )
        }
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                UIAction(title: "Закрепить") { _ in
                    
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    guard let self, let viewModel else { return }
                    
                    presentTrackerFormViewController(
                        with: viewModel.tracker(at: indexPath),
                        at: viewModel.category(at: indexPath.section)
                    )
                },
                UIAction(title: "Удалить", attributes: [.destructive]) { [weak self] _ in
                    self?.presentAlertToRemoveTracker(at: indexPath)
                }
            ])
        })
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell 
        else { return nil }
        
        return cell.targetedPreview
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: geometricParams.leftInset, bottom: 16, right: geometricParams.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        geometricParams.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(geometricParams.cellCount)
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCellComplete(cell: TrackerCollectionViewCell) {
        guard 
            let viewModel,
            let indexPath = trackersCollectionView.indexPath(for: cell)
        else { return }
        
        viewModel.completeTracker(at: indexPath)
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func createTracker(
        _ viewController: CreateTrackerViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    ) {
        viewController.dismiss(animated: true) { [weak self] in
            self?.viewModel?.addTrackerToCategory(trackerCategory, tracker: tracker)
        }
    }
}
