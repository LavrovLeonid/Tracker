//
//  TextFieldCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/11/24.
//

import Foundation

protocol TextFieldCollectionViewCellDelegate: AnyObject {
    func textFieldChangeValue(_ cell: TextFieldCollectionViewCell, with value: String)
}
