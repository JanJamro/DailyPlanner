//
//  EventDetailViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 11/07/2026.
//
import UIKit
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
    
    func readImage() -> UIImage? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documents.appendingPathComponent(event.imagePath ?? "").path
        if let image = UIImage(contentsOfFile: path) {
            return image
        }
        return nil
    }
}
