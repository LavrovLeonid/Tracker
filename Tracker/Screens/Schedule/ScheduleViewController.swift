//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import UIKit

final class ScheduleViewController: UIViewController, ScheduleViewControllerProtocol {
    private weak var delegate: ScheduleViewControllerDelegate?
    private let weekDays = WeekDay.allCases
    private var selectedWeekDays = Set<WeekDay>()
    
    private let schedulesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            ListItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    private lazy var submitButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        
        primaryButton.setTitle("Готово", for: .normal)
        primaryButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return primaryButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func configure(initialSelectedWeekDays: Set<WeekDay>, delegate: ScheduleViewControllerDelegate?) {
        self.delegate = delegate
        
        selectedWeekDays = Set(initialSelectedWeekDays)
    }
    
    private func setupView() {
        title = "Расписание"
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .trackerWhite
        
        view.addSubview(schedulesCollectionView)
        view.addSubview(submitButton)
        
        schedulesCollectionView.dataSource = self
        schedulesCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            schedulesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            schedulesCollectionView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16),
            schedulesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            schedulesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @IBAction private func submitButtonTapped() {
        delegate?.scheduleSubmit(self, selectedWeekDays: selectedWeekDays)
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let cell = cell as? ListItemCollectionViewCell {
            let weekDay = weekDays[indexPath.item]
            
            cell.configure(title: weekDay.title, delegate: self)
            cell.configure(placement: .getPlacement(at: indexPath.item, in: weekDays.count))
            cell.configure(endAdorment: .toggle(selectedWeekDays.contains(weekDay)))
        }
        
        return cell
    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 0,
            right: 16
        )
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
}

extension ScheduleViewController: ListItemCollectionCellDelegate {
    func listItem(_ cell: ListItemCollectionViewCell, toggle isOn: Bool) {
        guard let indexPath = schedulesCollectionView.indexPath(for: cell) else { return }
        
        let weekDay = weekDays[indexPath.item]
        
        if isOn {
            selectedWeekDays.insert(weekDay)
        } else {
            selectedWeekDays.remove(weekDay)
        }
    }
}
