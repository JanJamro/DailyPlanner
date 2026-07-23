//
//  EventDetailsViewController.swift
//  DailyPlanner
//
//  Created by Jan on 23/06/2026.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var event: Event!
    var viewModel: EventDetailViewModel!
    var dayVC: DayDetailViewController?
    var hourVC: HourDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = event.eventType!.eventTypeName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEvent))
        mapView.delegate = self
        viewModel = EventDetailViewModel(event: event)
        categoryImageView.image = UIImage(systemName: event.eventType!.iconName!)
        descriptionLabel.text = event.eventDescription
        let formatter = DateFormatter()
        formatter.dateFormat = "'To:' dd-MM-yyyy 'at' HH:mm"
        dateStartLabel.text = formatter.string(from: event.dateStart!)
        dateEndLabel.text = formatter.string(from: event.dateEnd!)
        let image = viewModel.readImage()
        if let image = image {
            categoryImageView.image = image
        }
        let address = event.address
        if let address = address {
            if address != "" {
                print("Map visible")
                mapView.isHidden = false
                addressLabel.text = address
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(event.latitude), longitude: CLLocationDegrees(event.longitude))
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.removeAnnotations(mapView.annotations)
                mapView.setRegion(region, animated: true)
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    @objc func deleteEvent() {
        if let hourVC = hourVC {
            hourVC.hourDetail.events.removeAll(where: { $0.id == event.id })
        }
        viewModel.deleteEvent()
        if let dayVC = dayVC {
            dayVC.fetchNeeded = true
        }
        navigationController?.popViewController(animated: true)
    }
}
