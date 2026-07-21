//
//  LocationChoosingViewController.swift
//  DailyPlanner
//
//  Created by Jan on 20/07/2026.
//

import UIKit
import MapKit

class LocationChoosingViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if resultsTableView.isHidden {
            resultsTableView.isHidden = false
        }
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultsTableView.reloadData()
        for result in searchResults {
            print(result.title)
            print(result.subtitle)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Result", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = searchResults[indexPath.row].title
        config.secondaryText = searchResults[indexPath.row].subtitle
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title = searchResults[indexPath.row].title
        searchBar.text = searchResults[indexPath.row].title
        resultsTableView.isHidden = true
    }
}
