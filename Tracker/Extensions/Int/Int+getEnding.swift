//
//  Int+getEnding.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/4/24.
//

import Foundation

extension Int {
    func getEnding(one: String = "", notMany: String = "а", many: String = "ов") -> String {
        let arrayNumbers = Array(String(self))
        
        let penultSymbol = arrayNumbers.count > 1 ? String(arrayNumbers[(arrayNumbers.count - 2)..<(arrayNumbers.count - 1)]) : nil
        let lastSymbol = arrayNumbers.last
        
        if (penultSymbol == "1") {
          return many;
        }
        
        switch (lastSymbol) {
            case "1":
                return one;
                
            case "2", "3", "4":
                return notMany;
                
            default:
                return many;
        }
    }
}
