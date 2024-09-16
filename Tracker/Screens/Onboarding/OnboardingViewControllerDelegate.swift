//
//  OnboardingViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/8/24.
//

import Foundation

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidComplete(_ viewController: OnboardingViewControllerProtocol)
}
