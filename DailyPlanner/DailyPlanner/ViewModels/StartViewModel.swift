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
    private let calendar = Calendar.current
    
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
        var weekday = calendar.component(.weekday, from: today)-2
        if weekday == -1 { weekday = 6 }
        let firstDateInGrid = calendar.date(byAdding: .day, value: -weekday, to: today)
        for dayNum in 0..<21 {
            let nextDay = calendar.date(byAdding: .day, value: dayNum, to: firstDateInGrid!)
            let dayNumber = calendar.component(.day, from: nextDay!)
            days.append(dayNumber)
        }
        
        return days
    }
    
    func prepareDayandMonthName () -> (day: Int, month: String) {
        let date = Date()
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let formatter = DateFormatter()
        let monthName = formatter.monthSymbols[month-1]
        
        return (day, monthName)
    }
}
