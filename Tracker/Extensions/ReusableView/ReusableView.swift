//
//  ReusableView.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIResponder {
    static var reuseIdentifier: String { .init(describing: self) }
}

