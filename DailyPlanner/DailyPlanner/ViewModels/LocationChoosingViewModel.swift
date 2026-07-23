//
//  LocationChoosingViewModel.swift
//  DailyPlanner
//
//  Created by Jan on 22/07/2026.
//
import Foundation
import MapKit

class LocationChoosingViewModel {
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    var selectedMapItem: MKMapItem?
    weak var eventAddingVC: EventAddingViewController!
    
    init(eventAddingVC: EventAddingViewController) {
        self.eventAddingVC = eventAddingVC
    }
    
    func save() {
        eventAddingVC.locationMapItem = selectedMapItem
        if let placemark = selectedMapItem?.placemark {
            eventAddingVC.address = placemark.thoroughfare! + " " + (placemark.subThoroughfare ?? "") + ", " + placemark.locality! + ", " + placemark.country!
        }
        eventAddingVC.locationAddressLabel.text = eventAddingVC.address
    }
}
