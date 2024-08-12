//
//  ListItemCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/7/24.
//

import UIKit

final class ListItemCollectionViewCell: UICollectionViewCell, ReusableView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .center
        
        return stackView
    }()
    private let innerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerBlack
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerGray
        
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .arrowRight
        
        return imageView
    }()
    private let dividerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .trackerGray
        
        return view
    }()
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = .trackerBlue
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        return switchControl
    }()
    
    private weak var delegate: ListItemCollectionCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        switchControl.isHidden = true
        arrowImageView.isHidden = true
        dividerView.isHidden = false
        titleLabel.text = ""
        descriptionLabel.text = ""
        layer.cornerRadius = 0
        delegate = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, description: String? = nil, delegate: ListItemCollectionCellDelegate? = nil) {
        self.delegate = delegate
        
        titleLabel.text = title
        
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
    }
    
    func configure(placement: ListItemCollectionCellPlacement) {
        layer.cornerRadius = 16
        
        switch placement {
            case .top:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom:
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                dividerView.isHidden = true
            case .middle:
                layer.cornerRadius = 0
            case .alone:
                dividerView.isHidden = true
        }
    }
    
    func configure(endAdorment: ListItemCollectionCellEndAdorment) {
        switch endAdorment {
            case .arrow:
                arrowImageView.isHidden = false
            case .toggle(let isOn):
                switchControl.isHidden = false
                switchControl.isOn = isOn
        }
    }
    
    private func setupView() {
        layer.masksToBounds = true
        contentView.backgroundColor = .trackerBackground
        
        arrowImageView.isHidden = true
        switchControl.isHidden = true
        
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(descriptionLabel)
        
        stackView.addArrangedSubview(innerStackView)
        
        stackView.addArrangedSubview(switchControl)
        stackView.addArrangedSubview(arrowImageView)
        
        contentView.addSubview(stackView)
        contentView.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -14),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @IBAction private func switchValueChanged(_ sender: UISwitch) {
        delegate?.listItem(self, toggle: sender.isOn)
    }
}
