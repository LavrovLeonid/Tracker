//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    private var completedTrackers = Set<TrackerRecord>()
    private var currentDate = Date()
    
    private let calendar = Calendar.current
    private var currentWeekday: WeekDay {
        WeekDay(rawValue: calendar.dateComponents([.weekday], from: currentDate).weekday ?? 1) ?? .monday
    }
    
    private var filteredCategories: [TrackerCategory] = []
    
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
        datePicker.locale = calendar.locale
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private var geometricParams = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupView()
        
        fetchCategories()
    }
    
    private func setupView() {
        view.backgroundColor = .trackerWhite
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        view.addSubview(emptyView)
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func presentEmptyView() {
        trackersCollectionView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func presentTrackersCollectionView() {
        trackersCollectionView.isHidden = false
        emptyView.isHidden = true
        
        trackersCollectionView.reloadData()
    }
    
    private func setupNavigationItem() {
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
    }
    
    private func getTrackerCategory(at index: Int) -> TrackerCategory {
        filteredCategories[index]
    }
    
    private func getTracker(at indexPath: IndexPath) -> Tracker {
        getTrackerCategory(at: indexPath.section).trackers[indexPath.item]
    }
    
    private func getTrackerRecord(at indexPath: IndexPath) -> TrackerRecord {
        let tracker = getTracker(at: indexPath)
        
        return TrackerRecord(trackerId: tracker.id, date: currentDate)
    }
    
    private func fetchCategories() {
        let categories: [TrackerCategory] = self.categories.reduce([]) { partialResult, category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.type == .event || tracker.schedules.contains(currentWeekday)
            }
            
            if !filteredTrackers.isEmpty {
                return partialResult + [
                    TrackerCategory(
                        name: category.name,
                        trackers: filteredTrackers
                    )
                ]
            }
            
            return partialResult
        }
        
        if categories.isEmpty {
            presentEmptyView()
        } else {
            self.filteredCategories = categories
            
            presentTrackersCollectionView()
            
            trackersCollectionView.reloadData()
        }
    }
    
    private func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        if categories.contains(category) {
            categories = categories.reduce([], { partialResult, trackerCategory in
                if trackerCategory == category {
                    let newTrackerCategory = TrackerCategory(
                        name: trackerCategory.name,
                        trackers: trackerCategory.trackers + [tracker]
                    )
                    
                    return partialResult + [newTrackerCategory]
                }
                
                return partialResult + [trackerCategory]
            })
        } else {
            let newTrackerCategory = TrackerCategory(
                name: category.name,
                trackers: [tracker]
            )
            
            categories = categories + [newTrackerCategory]
        }
        
        fetchCategories()
    }
    
    private func setCurrentDate(_ date: Date) {
        currentDate = date
        
        fetchCategories()
    }
    
    @IBAction private func addTrackerCategoryTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        
        createTrackerViewController.configure(with: self)
        
        present(UINavigationController(rootViewController: createTrackerViewController), animated: true)
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        setCurrentDate(sender.date)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
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
            cell.configure(with: getTrackerCategory(at: indexPath.section).name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? TrackerCollectionViewCell {
            let tracker = getTracker(at: indexPath)
            let trackerRecord = getTrackerRecord(at: indexPath)
            
            cell.setupCell(
                with: tracker,
                quantity: completedTrackers.filter { $0.trackerId == tracker.id }.count,
                isSelected: completedTrackers.contains(trackerRecord),
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
        guard indexPaths.count > 0 else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                UIAction(title: "Закрепить") { _ in
                    
                },
                UIAction(title: "Редактировать") { _ in
                    
                },
                UIAction(title: "Удалить", attributes: [.destructive]) { _ in
                    
                }
            ])
        })
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
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
        guard let indexPath = trackersCollectionView.indexPath(for: cell) else { return }
        
        let trackerRecord = getTrackerRecord(at: indexPath)
        let second = calendar.dateComponents([.second], from: Date(), to: trackerRecord.date).second ?? 0
        
        guard calendar.isDateInToday(trackerRecord.date) || second < 0 else { return }
        
        completedTrackers = completedTrackers.symmetricDifference([trackerRecord])
        
        trackersCollectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func createTracker(
        _ viewController: CreateTrackerViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    ) {
        viewController.dismiss(animated: true) { [weak self] in
            self?.addTracker(tracker, at: trackerCategory)
        }
    }
}
