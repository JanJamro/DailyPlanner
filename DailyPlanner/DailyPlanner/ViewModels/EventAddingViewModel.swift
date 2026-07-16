//
//  EventManagementViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 02/06/2026.
//
import UIKit

class EventAddingViewModel {
    let CDManager = CoreDataManagement.shared
    var startDate: Date!
    var endDate: Date!
    var description: String?
    var address: String?
    var imagePath: String?
    var categoryName: String!
    var longitude: Double?
    var latitude: Double?
    var eventTypes: [String] = []
    
    init(startDate: Date?) {
        if let startDate = startDate {
            self.startDate = startDate
        }
    }
    
    func getEventTypes() -> [String] {
        if eventTypes.isEmpty {
            eventTypes = CDManager.getEventTypesNames()
        }
        return eventTypes
    }
    
    func createEvent() {
        CDManager.createNewEvent(dateStart: startDate, dateEnd: endDate, categoryName: categoryName, description: description, imagePath: imagePath, address: address, longitude: longitude, latitude: latitude)
    }
    
    func savePhotoOnDeviceAndReturnFileName(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageName = UUID().uuidString
            let path = documents.appendingPathComponent(imageName)
            do {
                try data.write(to: path)
            }
            catch {
                print("Unable to save image to path")
            }
            return imageName
        }
        return nil
    }
}
