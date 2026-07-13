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
    private var daysForMiniCalendar: [Int] = []
    private var today: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingEventsTable.dataSource = self
        upcomingEventsTable.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        if let layout = daysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0.5
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
        daysCollectionView.layer.borderWidth = 1
        daysCollectionView.backgroundColor = .black
        daysCollectionView.bounces = false
        today = viewModel.prepareDayandMonthName().day
        monthLabel.text = viewModel.prepareDayandMonthName().month
        title = "Daily Planner"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "ChalkboardSE-Bold", size: 24)!,
        ]
    }
    
    @IBAction func miniCalendarViewTapped(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Calendar") as? CalendarViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func upcomingEventsViewTapped(_ sender: UITapGestureRecognizer) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingEvents") as? UpcomingEventsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
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
        daysForMiniCalendar = viewModel.prepareDaysForCells()
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as? MiniCalendarCell {
            cell.dayLabel.text = String(daysForMiniCalendar[indexPath.item])
            if daysForMiniCalendar[indexPath.item] == today {
                cell.backgroundColor = .systemBlue
            }
            else if daysForMiniCalendar[indexPath.item] < today - 6 {
                cell.backgroundColor = .systemGray5
                cell.dayLabel.layer.opacity = 0.3
            }
            else {
                cell.backgroundColor = .white
            }
            cell.layer.borderWidth = 0.3
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(collectionView.bounds.width / 7)
        let height = floor(collectionView.bounds.height / 3)
        return CGSize(width: width, height: height)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        upcomingEventsTable.reloadData()
    }

}
