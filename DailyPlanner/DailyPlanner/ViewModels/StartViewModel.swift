//
//  StartViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 26/05/2026.
//

import UIKit
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
}
