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
    var calendarDays: [CalendarDay] = []
    var monthForCalendar: Int!
    var monthForCalendarName: String!
    var yearForCalendar: Int!
    init() {
        currentDate = Date()
        monthForCalendar = calendar.component(.month, from: currentDate)
        let dateFormatter = DateFormatter()
        monthForCalendarName = dateFormatter.monthSymbols[monthForCalendar-1]
        yearForCalendar = calendar.component(.year, from: currentDate)
        generateMonth()
    }
    
    func generateMonth() {
        calendarDays.removeAll()
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: currentDate))
        let weekday = calendar.component(.weekday, from: firstOfMonth!)
        var numberOfDaysFromPreviousMonth = weekday - 2
        if numberOfDaysFromPreviousMonth < 0 {
            numberOfDaysFromPreviousMonth = 6
        }
        let firstDateInGrid = calendar.date(byAdding: .day, value: -numberOfDaysFromPreviousMonth, to: firstOfMonth!)!
        for day in 0..<42 {
            if let newDay = calendar.date(byAdding: .day, value: day, to: firstDateInGrid) {
                let isCurrentMonth = calendar.component(.month, from: newDay) == calendar.component(.month, from: currentDate)
                //here events will be
                let calendarDay = CalendarDay(date: newDay, events: [], isCurrentMonth: isCurrentMonth)
                calendarDays.append(calendarDay)
            }
        }
        
    }
    
    func changeMonth(upwards: Bool) {
        if upwards {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)
        }
        else {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)
        }
        monthForCalendar = calendar.component(.month, from: currentDate)
        yearForCalendar = calendar.component(.year, from: currentDate)
        let dateFormatter = DateFormatter()
        monthForCalendarName = dateFormatter.monthSymbols[monthForCalendar-1]
        generateMonth()
    }
}
