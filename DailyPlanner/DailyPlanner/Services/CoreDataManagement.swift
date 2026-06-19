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
    var fetchedResults: [EventType] = []
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
        
        /*let testEvent = Event(context: context)
        testEvent.dateStart = Date()+3600
        testEvent.dateEnd = Date()+7200
        testEvent.eventDescription = "Test Event"*/
        
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
    
    func fetchEventsForMonth(dateStartFrom: Date, dateStartTo: Date) -> [Event] {
        let request = Event.fetchRequest()
        request.predicate = NSPredicate(format: "dateStart > %@ AND dateStart < %@", dateStartFrom as NSDate, dateStartTo as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "dateStart", ascending: true)]
        var events: [Event] = []
        do {
            events = try context.fetch(request)
        }
        catch {
            print("Unable to fetch with error: \(error)")
        }
        return events
    }
    
    func fetchEventsForDay(date: Date) -> [Event] {
        let request = Event.fetchRequest()
        request.predicate = NSPredicate(format: "dateStartDay <= %@ AND dateEnd >= %@", date as NSDate, date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "dateStart", ascending: true)]
        var events: [Event] = []
        do {
            events = try context.fetch(request)
        }
        catch {
            print("Unable to fetch with error: \(error)")
        }
        return events
    }
    
    func createNewEvent(dateStart: Date, dateEnd: Date, categoryName: String, description: String?, imagePath: String?, address: String?, longitude: Double?, latitude: Double?) {
        let event = Event(context: context)
        event.dateStart = dateStart
        event.dateEnd = dateEnd
        event.eventDescription = description
        event.address = address
        event.longitude = longitude ?? 0.0
        event.latitude = latitude ?? 0.0
        //event.imagePath
        
        let dateStartDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: dateStart))!
        event.dateStartDay = dateStartDay
        
        fetchEventTypes()
        for result in fetchedResults {
            if result.eventTypeName == categoryName {
                event.eventType = result
                break
            }
        }
        
        do {
            try context.save()
        }
        catch {
            print("Unable to save with error: \(error)")
        }
    }
    
    func fetchEventTypes() {
        if fetchedResults.isEmpty {
            let request = EventType.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "eventTypeName", ascending: true)]
            do {
                fetchedResults = try context.fetch(request)
            }
            catch {
                print("Unable to fetch with error: \(error)")
            }
        }
    }
    
    func getEventTypesNames() -> [String] {
        fetchEventTypes()
        var eventTypeNames: [String] = []
        for result in fetchedResults {
            let name = result.eventTypeName ?? ""
            eventTypeNames.append(name)
        }
        return eventTypeNames
    }
}
