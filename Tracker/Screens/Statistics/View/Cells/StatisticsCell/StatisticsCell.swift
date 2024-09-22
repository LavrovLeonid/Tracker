//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/21/24.
//

import UIKit

final class StatisticsCell: UICollectionViewCell, ReusableView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 12, weight: .regular)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with statisticType: StatisticType) {
        countLabel.text = String(statisticType.count)
        descriptionLabel.text = String(statisticType.description)
    }
    
    private func setupView() {
        contentView.setGradientBorder(
            width: 1,
            colors: [.statisticsGradient1, .statisticsGradient2, .statisticsGradient3],
            cornerRadius: 16
        )
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
