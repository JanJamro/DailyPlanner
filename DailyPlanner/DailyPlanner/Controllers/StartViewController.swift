//
//  StartViewController.swift
//  DailyPlanner
//
//  Created by Jan on 25/05/2026.
//

import UIKit
import CoreData

class StartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var upcomingEventsTable: UITableView!
    @IBOutlet weak var miniEventsView: UIView!
    @IBOutlet weak var miniCalendarView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    private let viewModel = StartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingEventsTable.dataSource = self
        upcomingEventsTable.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        if let layout = daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }
        
        viewModel.upcomingEventsFetchRequestController.delegate = self
        miniCalendarView.layer.borderWidth = 2
        miniCalendarView.layer.borderColor = UIColor.gray.cgColor
        miniCalendarView.layer.cornerRadius = 20
        miniEventsView.layer.borderWidth = 2
        miniEventsView.layer.borderColor = UIColor.gray.cgColor
        miniEventsView.layer.cornerRadius = 20
        daysCollectionView.layer.borderWidth = 2
        title = "Daily Planner"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = viewModel.upcomingEventsFetchRequestController.fetchedObjects {
            if events.isEmpty {
                return 1
            }
            else {
                return events.count
            }
        }
        print("Unable to get fetched objects")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath)
        if let events = viewModel.upcomingEventsFetchRequestController.fetchedObjects {
            if events.isEmpty {
                cell.detailTextLabel?.text = "No upcoming events"
                cell.textLabel?.text = ""
            }
            else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                
                cell.detailTextLabel?.text = events[indexPath.row].eventDescription
                cell.textLabel?.text = formatter.string(from: events[indexPath.row].dateStart!)
            }
            cell.detailTextLabel?.textAlignment = .center
            cell.textLabel?.textAlignment = .left
            cell.detailTextLabel?.numberOfLines = 0
        }
        else {
            print("Unable to get fetched objects")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath)
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        let height = floor(collectionView.bounds.height / 3)
        return CGSize(width: width, height: height)
    }

}
