//
//  CoreDataManagement.swift
//  DailyPlanner
//
//  Created by Jan on 23/05/2026.
//

import UIKit
import CoreData

class CoreDataManagement {
    static let shared = CoreDataManagement()
    
    var context: NSManagedObjectContext
    
    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func createAndSaveDefaultEventTypes(_ types: [String], icons: [String]) {
        for (type,icon) in zip(types,icons) {
            let newEventType = EventType(context: context)
            newEventType.eventTypeName = type
            newEventType.iconName = icon
        }
        
        let testEvent = Event(context: context)
        testEvent.dateStart = Date()+3600
        testEvent.dateEnd = Date()+7200
        testEvent.eventDescription = "Test Event"
        
        do {
            try context.save()
        }
        catch {
            print("Unable to save with error: \(error)")
        }
    }
    
    func createUpcomingEventsFetchRequest() -> NSFetchRequest<Event> {
        let request = Event.fetchRequest()
        request.predicate = NSPredicate(format: "dateStart > %@", Date() as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "dateStart", ascending: true)]
        
        return request
    }
}
