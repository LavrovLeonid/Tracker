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
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        
        return collectionView
    }()
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(
            image: .emptyTrackers,
            text: NSLocalizedString("trackersEmpty", comment: "Empty trackers state")
        )
        
        return emptyView
    }()
    private let notFoundView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(
            image: .notFoundTrackers,
            text: NSLocalizedString("trackersNotFound", comment: "Not found trackers state")
        )
        
        return emptyView
    }()
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .trackerBlue
        datePicker.locale = Calendar.current.locale
        
        datePicker.setValue(UIColor.black, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        
        if let subview = datePicker.subviews.first {
            datePicker.overrideUserInterfaceStyle = .light
            subview.backgroundColor = .trackerDatePickerBackground
            subview.layer.cornerRadius = 8
        }
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    private lazy var filtersButton: FiltersButton = {
        let filtersButton = FiltersButton()
        
        filtersButton.setTitle(NSLocalizedString("trackersFilters", comment: "Trackers filters"), for: .normal)
        filtersButton.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        
        return filtersButton
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
    private(set) var viewModel: ViewModel
    
    func bind() {
        viewModel.onTrackersPresentEmptyView = { [weak self] in
            guard let self else { return }
            
            presentEmptyView()
        }
        
        viewModel.onTrackersPresentNotFoundView = { [weak self] in
            guard let self else { return }
            
            presentNotFoundView()
        }
        
        viewModel.onTrackersPresentCollectionView = { [weak self] in
            guard let self else { return }
            
            presentTrackersCollectionView()
        }
        
        viewModel.onTrackersReloadCollectionView = { [weak self] in
            guard let self else { return }
            
            trackersCollectionView.reloadData()
        }
        
        viewModel.onTrackersStateChange = { [weak self] updates in
            guard let self else { return }
            
            trackersCollectionView.performBatchUpdates({
                self.trackersCollectionView.insertSections(updates.insertedSectionsIndexes)
                self.trackersCollectionView.reloadSections(updates.updatedSectionsIndexes)
                self.trackersCollectionView.deleteSections(updates.deletedSectionsIndexes)
                
                self.trackersCollectionView.insertItems(at: updates.insertedItemsIndexPaths)
                self.trackersCollectionView.reloadItems(at: updates.updatedItemsIndexPaths)
                self.trackersCollectionView.deleteItems(at: updates.deletedItemsIndexPaths)
                
                updates.movedItemsIndexPaths.forEach { indexPath, newIndexPath in
                    self.trackersCollectionView.moveItem(at: indexPath, to: newIndexPath)
                }
            }) { _ in
                self.viewModel.didFinishUpdates()
            }
        }
        
        viewModel.onTrackersSetDate = { [weak self] date in
            guard let self else { return }
            
            datePicker.setDate(date, animated: true)
        }
    }
    
    // MARK: Life cicle
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
    
    // MARK: PresentingViewController
    func setupView() {
        title = NSLocalizedString("trackersTitle", comment: "Trackers title")
        
        tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackersTitle", comment: "Trackers title"),
            image: .trackersIcon,
            tag: 0
        )
        
        let leftBarButtonItem = UIBarButtonItem(
            image: .plusIcon,
            style: .plain,
            target: self,
            action: #selector(addTrackerCategoryTapped)
        )
        leftBarButtonItem.tintColor = .trackerBlack
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.addTarget(
            self,
            action: #selector(searchTextFieldEditingChanged(_:)),
            for: .editingChanged
        )
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.backgroundColor = .trackerWhite
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
    }
    
    func setupSubviews() {
        view.addSubview(emptyView)
        view.addSubview(notFoundView)
        view.addSubview(trackersCollectionView)
        view.addSubview(filtersButton)
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
            
            notFoundView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            notFoundView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            notFoundView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Methods
    private func presentEmptyView() {
        trackersCollectionView.isHidden = true
        emptyView.isHidden = false
        notFoundView.isHidden = true
        filtersButton.isHidden = true
    }
    
    private func presentTrackersCollectionView() {
        trackersCollectionView.isHidden = false
        emptyView.isHidden = true
        notFoundView.isHidden = true
        filtersButton.isHidden = false
    }
    
    private func presentNotFoundView() {
        trackersCollectionView.isHidden = true
        emptyView.isHidden = true
        notFoundView.isHidden = false
        filtersButton.isHidden = false
    }
    
    // MARK: Routing
    private func presentCreateTrackerCategoryViewController() {
        let createTrackerViewController = CreateTrackerViewController()
        
        createTrackerViewController.configure(with: self)
        
        present(
            UINavigationController(rootViewController: createTrackerViewController),
            animated: true
        )
    }
    
    private func presentTrackerFormViewController(at indexPath: IndexPath) {
        let trackerFormViewController = TrackerFormViewController()
        
        trackerFormViewController.configure(
            with: viewModel.tracker(at: indexPath),
            completeCount: viewModel.countTrackerRecords(at: indexPath),
            at: viewModel.originCategory(at: indexPath),
            delegate: self
        )
        
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
            UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                guard let self else { return }
                
                viewModel.removeTracker(at: indexPath)
            }
        )
        alertController.addAction(
            UIAlertAction(title: "Отменить", style: .cancel)
        )
        
        present(alertController, animated: true)
    }
    
    private func presentFiltersViewController() {
        let trackersFilterViewController = TrackersFilterViewController()
        
        trackersFilterViewController.configure(
            appliedFilter: viewModel.appliedFilter,
            delegate: self
        )
        
        present(
            UINavigationController(rootViewController: trackersFilterViewController),
            animated: true
        )
    }
    
    // MARK: Actions
    @IBAction private func addTrackerCategoryTapped() {
        presentCreateTrackerCategoryViewController()
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.setCurrentDate(sender.date)
    }
    
    @IBAction private func searchTextFieldEditingChanged(_ searchField: UISearchTextField) {
        viewModel.setSearchText(searchField.text ?? "")
    }
    
    @IBAction private func filtersButtonTapped() {
        presentFiltersViewController()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfItemsInSection(section)
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
            cell.configure(with: viewModel.category(at: indexPath.section).name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? TrackerCollectionViewCell {
            cell.setupCell(
                with: viewModel.tracker(at: indexPath),
                quantity: viewModel.countTrackerRecords(at: indexPath),
                isSelected: viewModel.isCompletedTracker(at: indexPath),
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
        
        let isPinned = viewModel.isPinnedTracker(at: indexPath)
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                UIAction(title: isPinned ? "Открепить" : "Закрепить") { [weak self] _ in
                    guard let self else { return }
                    
                    viewModel.pinTrackerTapped(at: indexPath)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    guard let self else { return }
                    
                    presentTrackerFormViewController(at: indexPath)
                },
                UIAction(title: "Удалить", attributes: [.destructive]) { [weak self] _ in
                    guard let self else { return }
                    
                    presentAlertToRemoveTracker(at: indexPath)
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
        UIEdgeInsets(
            top: 12,
            left: geometricParams.leftInset,
            bottom: 16,
            right: geometricParams.rightInset
        )
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
        .zero
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCellComplete(cell: TrackerCollectionViewCell) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell) else { return }
        
        viewModel.completeTrackerTapped(at: indexPath)
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func createTracker(
        _ viewController: CreateTrackerViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    ) {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            viewModel.addTracker(tracker, to: trackerCategory)
        }
    }
}

extension TrackersViewController: TrackerFormViewControllerDelegate {
    func trackerFormCancel(_ viewController: TrackerFormViewControllerProtocol) {
        viewController.dismiss(animated: true)
    }
    
    func trackerFormSubmit(
        _ viewController: TrackerFormViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    ) {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            viewModel.editTracker(tracker, at: trackerCategory)
        }
    }
}

extension TrackersViewController: TrackersFilterViewControllerDelegate {
    func applyFilter(
        _ viewController: TrackersFilterViewControllerProtocol,
        filter: TrackersFilter
    ) {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            viewModel.setFilter(filter)
        }
    }
}
