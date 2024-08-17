//
//  PresentingViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/17/24.
//

import UIKit

protocol PresentingViewController where Self: UIViewController {
    func setupView()
    func setupSubviews()
    func setupConstraints()
}
