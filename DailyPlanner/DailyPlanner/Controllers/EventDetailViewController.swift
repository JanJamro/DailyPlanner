//
//  EventDetailsViewController.swift
//  DailyPlanner
//
//  Created by Jan on 23/06/2026.
//

import UIKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    var event: Event!
    var viewModel: EventDetailViewModel!
    var dayVC: DayDetailViewController?
    var hourVC: HourDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = event.eventType!.eventTypeName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEvent))
        
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
