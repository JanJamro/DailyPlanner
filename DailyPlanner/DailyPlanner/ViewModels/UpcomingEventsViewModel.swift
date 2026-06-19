//
//  UpcomingEventsViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 05/06/2026.
//

import Foundation
import CoreData

class UpcomingEventsViewModel {
    var upcomingEventsFetchController: NSFetchedResultsController<Event>
    let CDManager = CoreDataManagement.shared
    
    init() {
        let request = CDManager.createUpcomingEventsFetchRequest()
        upcomingEventsFetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDManager.context, sectionNameKeyPath: "dateStartDay", cacheName: nil)
        fetchUpcomingEvents()
    }
    
    func fetchUpcomingEvents() {
        do {
            try upcomingEventsFetchController.performFetch()
        } catch {
            print("Failed to fetch upcoming events: \(error)")
        }
    }
}
