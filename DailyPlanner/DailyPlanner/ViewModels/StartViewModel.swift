//
//  StartViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 26/05/2026.
//

import Foundation
import CoreData

class StartViewModel {
    private let CDManager = CoreDataManagement.shared
    var upcomingEventsFetchRequestController: NSFetchedResultsController<Event>!
    
    init() {
        let request = CDManager.createUpcomingEventsFetchRequest()
        upcomingEventsFetchRequestController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDManager.context, sectionNameKeyPath: nil, cacheName: nil)
        upcomingEventsFetchRequestController.fetchRequest.fetchLimit = 5
        
        do {
            try upcomingEventsFetchRequestController.performFetch()
        }
        catch {
            print("Failed to fetch upcoming events: \(error)")
        }
    }
    
    func prepareDaysForCells() -> [Int] {
        var days: [Int] = []
        let today = Date()
        let callendar = Calendar.current
        var weekday = callendar.component(.weekday, from: today)-2
        if weekday == -1 { weekday = 6 }
        for dayNum in 0..<weekday {
            let newDay = callendar.date(byAdding: .day, value: -weekday + dayNum, to: today)
            days.append(callendar.component(.day, from: newDay!))
        }
        let remainingSpots = 21 - days.count
        for dayNum in 0..<remainingSpots {
            let nextDay = callendar.date(byAdding: .day, value: dayNum, to: today)
            let dayNumber = callendar.component(.day, from: nextDay!)
            days.append(dayNumber)
        }
        
        return days
    }
    
    func prepareDayandMonthName () -> (day: Int, month: String) {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let formatter = DateFormatter()
        let monthName = formatter.monthSymbols[month-1]
        
        return (day, monthName)
    }
}
