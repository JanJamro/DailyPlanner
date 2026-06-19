//
//  DayDetailViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 31/05/2026.
//

import Foundation
import CoreData

class DayDetailViewModel {
    var date: Date!
    var events: [Event] = []
    let calendar = Calendar.current
    let CDManager = CoreDataManagement.shared
    
    init(date: Date, events: [Event]) {
        self.date = date
        self.events = events
    }
    
    func moveToPreviousDay() {
        date = calendar.date(byAdding: .day, value: -1, to: date)
    }
    
    func moveToNextDay() {
        date = calendar.date(byAdding: .day, value: 1, to: date)
    }
    
    func getEvents() -> [Event] {
        return CDManager.fetchEventsForDay(date: date)
    }
    
    func timeInMinutesFromString(timeString: String) -> Int {
        let timeComponents = timeString.split(separator: ":")
        guard let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) else {
            return 0
        }
        return hour * 60 + minute
    }
    
    func timeInMinutesFromDate(date: Date) -> Int {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        return hour * 60 + minute
    }
}
