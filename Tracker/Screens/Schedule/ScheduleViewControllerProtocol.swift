//
//  ScheduleViewControllerProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import UIKit

protocol ScheduleViewControllerProtocol: UIViewController {
    func configure(initialSelectedWeekDays: Set<WeekDay>, delegate: ScheduleViewControllerDelegate?)
}
