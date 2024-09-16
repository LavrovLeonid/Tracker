//
//  BindableViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import UIKit

protocol BindableViewController where Self: UIViewController {
    associatedtype ViewModel
    
    var viewModel: ViewModel { get }
    
    func bind()
}
