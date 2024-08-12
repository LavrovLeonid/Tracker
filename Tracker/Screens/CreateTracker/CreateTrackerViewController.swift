//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/4/24.
//

import UIKit

final class CreateTrackerViewController: UIViewController, CreateTrackerViewControllerProtocol {
    private var delegate: CreateTrackerViewControllerDelegate?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    private lazy var habitButton: PrimaryButton = {
        let button = PrimaryButton()
        
        button.setTitle(TrackerType.habit.text, for: .normal)
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var eventButton: PrimaryButton = {
        let button = PrimaryButton()
        
        button.setTitle(TrackerType.event.text, for: .normal)
        button.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func configure(with delegate: CreateTrackerViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func setupView() {
        title = "Создание трекера"
        
        view.backgroundColor = .trackerWhite
        
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction private func habitButtonTapped() {
        let trackerFormViewController = TrackerFormViewController()
        
        trackerFormViewController.configure(trackerType: .habit, delegate: self)
        
        navigationController?.pushViewController(trackerFormViewController, animated: true)
    }
    
    @IBAction private func eventButtonTapped() {
        let trackerFormViewController = TrackerFormViewController()
        
        trackerFormViewController.configure(trackerType: .event, delegate: self)
        
        navigationController?.pushViewController(trackerFormViewController, animated: true)
    }
}

extension CreateTrackerViewController: TrackerFormViewControllerDelegate {
    func trackerFormSubmit(
        _ viewController: TrackerFormViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    ) {
        delegate?.createTracker(self, trackerCategory: trackerCategory, tracker: tracker)
    }
    
    func trackerFormCancel(_ viewController: TrackerFormViewControllerProtocol) {
        dismiss(animated: true)
    }
}
