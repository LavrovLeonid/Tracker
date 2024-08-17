//
//  TextFieldCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/5/24.
//

import UIKit

final class TextFieldCollectionViewCell: UICollectionViewCell, ReusableView {
    private lazy var textField: TextField = {
        let textField = TextField()
        
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    private weak var delegate: TextFieldCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        text: String,
        placeholder: String = "",
        delegate: TextFieldCollectionViewCellDelegate? = nil
    ) {
        self.delegate = delegate
        
        textField.text = text
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.trackerGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
    }
    
    private func setupView() {
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: TextField) {
        delegate?.textFieldChangeValue(self, with: sender.text ?? "")
    }
}
