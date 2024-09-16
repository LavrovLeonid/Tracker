//
//  OnboardingServiceProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/8/24.
//

import Foundation

protocol OnboardingServiceProtocol {
    var isComplete: Bool { get }
    
    func complete()
    func reset()
}
