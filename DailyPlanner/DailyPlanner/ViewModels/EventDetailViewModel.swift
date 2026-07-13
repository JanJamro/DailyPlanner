//
//  EventDetailViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 11/07/2026.
//
import Foundation
import CoreData

class EventDetailViewModel {
    var event: Event
    let CDManager = CoreDataManagement.shared
    init(event: Event) {
        self.event = event
    }
    
    func deleteEvent() {
        CDManager.deleteEvent(event)
    }
}
