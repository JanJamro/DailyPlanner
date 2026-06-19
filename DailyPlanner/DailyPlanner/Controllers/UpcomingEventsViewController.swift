//
//  UpcomingEventsViewController.swift
//  DailyPlanner
//
//  Created by Jan on 05/06/2026.
//

import UIKit
import CoreData

class UpcomingEventsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = UpcomingEventsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Events"
        viewModel.upcomingEventsFetchController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.upcomingEventsFetchController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingEventsFetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as? UpcomingEventCell {
            cell.descriptionLabel.text = viewModel.upcomingEventsFetchController.object(at: indexPath).eventDescription
            let formatter = DateFormatter()
            formatter.dateFormat = "'From:' HH:mm"
            cell.dateStartLabel.text = formatter.string(from: viewModel.upcomingEventsFetchController.object(at: indexPath).dateStart!)
            formatter.dateFormat = "'To:' dd-MM-yyyy 'at' HH:mm"
            cell.dateEndLabel.text = formatter.string(from: viewModel.upcomingEventsFetchController.object(at: indexPath).dateEnd!)
            if let image = UIImage(systemName: viewModel.upcomingEventsFetchController.object(at: indexPath).eventType!.iconName!) {
                cell.iconImageView.image = image
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = formatter.date(from: viewModel.upcomingEventsFetchController.sections![section].name)
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date!)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
