//
//  LocationChoosingViewController.swift
//  DailyPlanner
//
//  Created by Jan on 20/07/2026.
//

import UIKit
import MapKit
import CoreLocation

class LocationChoosingViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    weak var eventAddingVC: EventAddingViewController!
    var viewModel: LocationChoosingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LocationChoosingViewModel(eventAddingVC: eventAddingVC)
        searchBar.delegate = self
        viewModel.searchCompleter.delegate = self
        viewModel.searchCompleter.resultTypes = .address
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        let tapHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapHideKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapHideKeyboard)
        let longPressOnMap = UILongPressGestureRecognizer(target: self, action: #selector(addPointOnMap))
        longPressOnMap.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressOnMap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if resultsTableView.isHidden {
            resultsTableView.isHidden = false
        }
        else if searchText.isEmpty {
            resultsTableView.isHidden = true
        }
        viewModel.searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        viewModel.searchResults = completer.results
        resultsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Result", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = viewModel.searchResults[indexPath.row].title
        config.secondaryText = viewModel.searchResults[indexPath.row].subtitle
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        title = viewModel.searchResults[indexPath.row].title
        searchBar.text = viewModel.searchResults[indexPath.row].title
        resultsTableView.isHidden = true
        
        let request = MKLocalSearch.Request(completion: viewModel.searchResults[indexPath.row])
        request.naturalLanguageQuery = viewModel.searchResults[indexPath.row].title + " " + viewModel.searchResults[indexPath.row].subtitle
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let mapItem = response?.mapItems.first else { return }
            
            let coordinate = mapItem.placemark.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self?.mapView.setRegion(region, animated: true)
            self?.mapView.removeAnnotations(self!.mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = mapItem.name
            self?.mapView.addAnnotation(annotation)
            self?.viewModel.selectedMapItem = mapItem
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addPointOnMap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            mapView.removeAnnotations(mapView.annotations)
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                    self?.viewModel.selectedMapItem = mapItem
                    DispatchQueue.main.async {
                        self?.title = mapItem.name
                        self?.searchBar.text = mapItem.name
                    }
                }
            }
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func saveLocation() {
        viewModel.save()
        navigationController?.popViewController(animated: true)
    }
}
