//
//  LocationChoosingViewController.swift
//  DailyPlanner
//
//  Created by Jan on 20/07/2026.
//

import UIKit
import MapKit

class LocationChoosingViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        for result in searchResults {
            print(result.title)
            print(result.subtitle)
        }
    }
}
