//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleSubmit(_ viewController: ScheduleViewControllerProtocol, selectedWeekDays: Set<WeekDay>)
}
