//
//  CategoryFormModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoryFormModelProtocol {
    var initialCategory: TrackerCategory? { get }
    var categoryName: String { get }
    
    func setCategoryName(_ name: String)
}
