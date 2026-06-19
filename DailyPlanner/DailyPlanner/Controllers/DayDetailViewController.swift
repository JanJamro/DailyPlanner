//
//  DayDetailViewController.swift
//  DailyPlanner
//
//  Created by Jan on 29/05/2026.
//

import UIKit

class DayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var hoursTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    var date: Date!
    var events: [Event] = []
    var fetchNeeded = false
    var viewModel: DayDetailViewModel!
    let hoursStart = ["0:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
    let hoursEnd = ["0:59", "1:59", "2:59", "3:59", "4:59", "5:59", "6:59", "7:59", "8:59", "9:59", "10:59", "11:59", "12:59", "13:59", "14:59", "15:59", "16:59", "17:59", "18:59", "19:59", "20:59", "21:59", "22:59", "23:59"]
    let eventLabelColors = [.systemOrange, .systemGreen, .systemPurple] as [UIColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        viewModel = DayDetailViewModel(date: date, events: events)
        formatDateAndUpdateView()
        title = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fetchNeeded {
            events = viewModel.getEvents()
            hoursTableView.reloadData()
            fetchNeeded = false
        }
    }
    
    @objc func addEvent() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EventManagement") as? EventAddingViewController {
            vc.titleText = "Create new event"
            vc.startDate = date
            vc.dayVC = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func moveToPreviousDay(_ sender: UIButton) {
        viewModel.moveToPreviousDay()
        date = viewModel.date
        events = viewModel.getEvents()
        formatDateAndUpdateView()
    }
    
    @IBAction func moveToNextDay(_ sender: UIButton) {
        viewModel.moveToNextDay()
        date = viewModel.date
        events = viewModel.getEvents()
        formatDateAndUpdateView()
        print("moved date to: \(date!)")
    }
    
    private func formatDateAndUpdateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        hoursTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Hour", for: indexPath) as? HoursCell {
            for event in events {
                var timeStart, timeEnd : Int
                let hourStart = viewModel.timeInMinutesFromString(timeString: hoursStart[indexPath.row])
                let hourEnd = viewModel.timeInMinutesFromString(timeString: hoursEnd[indexPath.row])
                if Calendar.current.isDate(event.dateStart!, inSameDayAs: event.dateEnd!) {
                    timeStart = viewModel.timeInMinutesFromDate(date: event.dateStart!)
                    timeEnd = viewModel.timeInMinutesFromDate(date: event.dateEnd!)
                }
                else if Calendar.current.isDate(event.dateStart!, inSameDayAs: date) {
                    timeStart = viewModel.timeInMinutesFromDate(date: event.dateStart!)
                    timeEnd = 1439 //23:59 in minutes
                }
                else if Calendar.current.isDate(event.dateEnd!, inSameDayAs: date) {
                    timeStart = 0
                    timeEnd = viewModel.timeInMinutesFromDate(date: event.dateEnd!)
                }
                else {
                    timeStart = 0
                    timeEnd = 1439
                }
                
                if (timeStart < hourStart && timeEnd < hourStart) || (timeStart > hourEnd && timeEnd > hourEnd) || timeEnd == hourStart {
                    
                }
                else {
                    if cell.eventLabelsCounter < 3 {
                        let label = UILabel()
                        label.text = "●"
                        label.translatesAutoresizingMaskIntoConstraints = false
                        cell.contentView.addSubview(label)
                        if cell.previousEventlabel == nil {
                            label.leadingAnchor.constraint(equalTo: cell.hourStartLabel.leadingAnchor).isActive = true
                            label.topAnchor.constraint(equalTo: cell.hourStartLabel.bottomAnchor, constant: 1).isActive = true
                            label.textColor = eventLabelColors[cell.eventLabelsCounter]
                        }
                        else {
                            label.topAnchor.constraint(equalTo: cell.previousEventlabel!.topAnchor).isActive = true
                            label.leadingAnchor.constraint(equalTo: cell.previousEventlabel!.trailingAnchor, constant: 5).isActive = true
                            label.textColor = eventLabelColors[cell.eventLabelsCounter]
                        }
                        cell.previousEventlabel = label
                        cell.eventLabelsCounter += 1
                    }
                    else {
                        let label = UILabel()
                        cell.contentView.addSubview(label)
                        label.text = "..."
                        label.translatesAutoresizingMaskIntoConstraints = false
                        label.topAnchor.constraint(equalTo: cell.previousEventlabel!.topAnchor).isActive = true
                        label.leadingAnchor.constraint(equalTo: cell.previousEventlabel!.trailingAnchor, constant: 5).isActive = true
                        label.textColor = .black
                        break;
                    }
                }
            }
            cell.previousEventlabel = nil
            cell.eventLabelsCounter = 0
            cell.hourStartLabel.text = hoursStart[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
