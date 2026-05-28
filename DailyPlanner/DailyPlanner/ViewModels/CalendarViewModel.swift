//
//  CalendarViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 28/05/2026.
//

import Foundation
import CoreData

class CalendarViewModel {
    private let CDManager = CoreDataManagement.shared
    var currentDate: Date!
    let calendar = Calendar.current
    init() {
        currentDate = Date()
    }
    
    func getCurrentDateParts() -> (day: Int, month: Int, monthName: String, year: Int) {
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let formatter = DateFormatter()
        let monthName = formatter.monthSymbols[month - 1]
        let year = calendar.component(.year, from: currentDate)
        return (day, month, monthName, year)
    }
}
