//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/22/24.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService: AnalyticsServiceProtocol {
    static let shared: AnalyticsServiceProtocol = AnalyticsService()
    private init() {}
    
    private let apiKey = "07f336b9-afb7-4b98-8989-8c1bc887acae"
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(_ event: AnalyticEvent, from screen: Screen) {
        YMMYandexMetrica.reportEvent(
            event.name,
            parameters: getReportParams(for: event, from: screen)
        ) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
    
    private func getReportParams(for event: AnalyticEvent, from screen: Screen) -> Dictionary<String, String> {
        var params = Dictionary<String, String>()
        
        params["screen"] = screen.rawValue
        
        if case .click(let analyticItem) = event {
            params["item"] = analyticItem.rawValue
        }
        
        return params
    }
}
