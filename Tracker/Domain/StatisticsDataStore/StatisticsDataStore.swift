//
//  StatisticsDataStore.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/19/24.
//

import CoreData
import UIKit

final class StatisticsDataStore: NSObject, StatisticsDataStoreProtocol {
    private var context = PersistentContainer.shared.context
    private let calendar = Calendar.current
    private let today = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        return formatter
    }
    
    private lazy var trackerRecordsFetchedResultsController = {
        let fetchRequest = TrackerRecordEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                key: #keyPath(TrackerRecordEntity.date),
                ascending: true
            )
        ]
        
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordEntity.tracker.type),
            NSNumber(value: TrackerType.habit.rawValue)
        )
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    private var trackerRecordsEntities: [TrackerRecordEntity] {
        trackerRecordsFetchedResultsController.fetchedObjects ?? []
    }
    
    weak var delegate: StatisticsDataStoreDelegate?
    
    var isEmptyStatistic: Bool {
        trackerRecordsEntities.isEmpty
    }
    
    func fetchStatistic() -> [StatisticType] {
        guard !trackerRecordsEntities.isEmpty else { return [] }
        
        let trackerEntities = fetchTrackerEntities()
        
        // Сгруппированные записи трекеров по дате
        let trackerRecordsByDate = Dictionary(grouping: trackerRecordsEntities) { object in
            dateFormatter.date(
                from: dateFormatter.string(from: object.date ?? Date())
            )
        }
        
        // Сгруппированное количество трекеров по дням недели
        var trackersCountByWeekDays = Dictionary<Int, Int>()
        
        trackerEntities.forEach { trackerEntity in
            let weekDays = trackerEntity.schedules?
                .split(separator: ",")
                .compactMap { Int($0) } ?? []
            
            weekDays.forEach { weekDay in
                trackersCountByWeekDays[weekDay] = (trackersCountByWeekDays[weekDay] ?? 0) + 1
            }
        }
        
        // Дата первого выполненного трекера
        let startDate = trackerRecordsEntities.first?.date ?? Date()
        
        // Дата последнего выполненного трекера
        let endDate = trackerRecordsEntities.last?.date ?? Date()
        
        // Переменные для подсчета статистики
        var bastPeriods = Set<Int>()
        var currentBestPeriod = 0
        var prefectDays: Int = 0
        
        // Перебор всех дней, от первого выполненного трекера до последнего
        calendar.enumerateDates(
            startingAfter: startDate,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { (date, _, stop) in
            guard
                let date,
                date <= endDate,
                let weekDay = calendar.dateComponents([.weekday], from: date).weekday
            else {
                stop = true
                
                // Не забываем добавить счетчик на последней итерации
                bastPeriods.insert(currentBestPeriod)
                
                return
            }
            
            guard
                let trackersCountAtWeekDay = trackersCountByWeekDays[weekDay],
                trackersCountAtWeekDay > 0
            else { return }
            
            let recordsCountAtDay = (trackerRecordsByDate[date] ?? []).count
            
            // Проверяем, совпадает ли количество выполенных трекеров за день с общим количеством трекеров, заведенных на этот день недели
            if trackersCountAtWeekDay == recordsCountAtDay {
                currentBestPeriod += 1
                prefectDays += 1
            } else {
                bastPeriods.insert(currentBestPeriod)
                currentBestPeriod = 0
            }
        }
        
        // Получаем среднее количество трекеров, выполненных за всё время
        let averageValue = trackerRecordsByDate.count > 0 ? trackerRecordsEntities.count / trackerRecordsByDate.count : 0
        
        return [
            .bestPeriod(bastPeriods.max() ?? 0),
            .perfectDays(prefectDays),
            .completedTrackers(trackerRecordsEntities.count),
            .averageValue(averageValue)
        ]
    }
    
    private func fetchTrackerEntities() -> [TrackerEntity] {
        let trackersFetchRequest = TrackerEntity.fetchRequest()
        
        trackersFetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerEntity.type),
            NSNumber(value: TrackerType.habit.rawValue)
        )
        
        return (try? context.fetch(trackersFetchRequest)) ?? []
    }
}

extension StatisticsDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.didUpdate()
    }
}
