//
//  TrackerQuantityManagmentView.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/28/24.
//

import UIKit

final class TrackerQuantityManagmentView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let quantityLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .trackerBlack
        
        return label
    }()
    private lazy var ellipseButton: EllipseButton = {
        let button = EllipseButton()
        
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private weak var delegate: TrackerQuantityManagmentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        quantity: Int,
        buttonBackground: UIColor,
        isSelected: Bool,
        delegate: TrackerQuantityManagmentViewDelegate?
    ) {
        self.delegate = delegate
        
        quantityLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of completed days"),
            quantity
        )
        
        if isSelected {
            ellipseButton.backgroundColor = buttonBackground.withAlphaComponent(0.3)
            ellipseButton.setImage(.doneIcon, for: .normal)
        } else {
            ellipseButton.backgroundColor = buttonBackground
            ellipseButton.setImage(.plusIcon, for: .normal)
        }
    }
    
    @IBAction private func selectButtonTapped() {
        delegate?.trackerQuantityManagmentDidTapped()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        stackView.addArrangedSubview(quantityLabel)
        stackView.addArrangedSubview(ellipseButton)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
