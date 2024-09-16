//
//  OnboardingService.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/8/24.
//

import Foundation

final class OnboardingService: OnboardingServiceProtocol {
    private let onboardingCompleteKey = "onboardingComplete"
    private let userDefaults = UserDefaults.standard
    
    private(set) var isComplete: Bool {
        get {
            userDefaults.bool(forKey: onboardingCompleteKey)
        }
        set {
            userDefaults.set(newValue, forKey: onboardingCompleteKey)
        }
    }
    
    func complete() {
        isComplete = true
    }
    
    func reset() {
        isComplete = false
    }
}
