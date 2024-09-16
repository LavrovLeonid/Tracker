//
//  CategoryFormViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoryFormViewModelProtocol {
    var onEnableSubmitButtonStateChange: Binding<Bool>? { get set }
    var onIsNewCategoryStateChange: Binding<Bool>? { get set }
    var onInitialCategoryNameStateChange: Binding<String>? { get set }
    var onCategorySubmit: Binding<TrackerCategory>? { get set }
    
    func viewDidLoad()
    func changeCategoryName(_ name: String)
    func submitButtonTapped()
}
