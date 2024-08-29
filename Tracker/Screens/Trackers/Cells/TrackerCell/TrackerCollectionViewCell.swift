//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/28/24.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell, ReusableView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        return stackView
    }()
    private let trackerCardView = TrackerCardView()
    private let trackerQuantityManagmentView = TrackerQuantityManagmentView()
    
    private weak var delegate: TrackerCollectionViewCellDelegate?
    
    lazy var targetedPreview: UITargetedPreview = {
        UITargetedPreview(view: trackerCardView)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with tracker: Tracker, quantity: Int, isSelected: Bool, delegate: TrackerCollectionViewCellDelegate?) {
        self.delegate = delegate
        
        trackerCardView.configure(with: tracker)
        trackerQuantityManagmentView.configure(
            quantity: quantity, buttonBackground: tracker.color, isSelected: isSelected, delegate: self
        )
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        stackView.addArrangedSubview(trackerCardView)
        stackView.addArrangedSubview(trackerQuantityManagmentView)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension TrackerCollectionViewCell: TrackerQuantityManagmentViewDelegate {
    func trackerQuantityManagmentDidTapped() {
        delegate?.trackerCellComplete(cell: self)
    }
}
