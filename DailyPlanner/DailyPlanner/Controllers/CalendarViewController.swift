//
//  CalendarViewController.swift
//  DailyPlanner
//
//  Created by Jan on 28/05/2026.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var weekdaysCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    let viewModel = CalendarViewModel()
    let weekdaysShort = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var currentMonthName: String!
    var today: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        weekdaysCollectionView.delegate = self
        weekdaysCollectionView.dataSource = self
        today = Calendar.current.component(.day, from: viewModel.currentDate)
        
        title = String(viewModel.yearForCalendar)
        monthLabel.text = viewModel.monthForCalendarName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        if let layout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
            layout.estimatedItemSize = .zero
        }
        
        if let layout = weekdaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }
        
        calendarCollectionView.layer.borderWidth = 1
        calendarCollectionView.backgroundColor = .black
        calendarCollectionView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.generateMonth()
        calendarCollectionView.reloadData()
    }
    
    @objc func addEvent() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EventManagement") as? EventAddingViewController {
            vc.titleText = "Create new event"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func moveToNextMonth(_ sender: UIButton) {
        viewModel.changeMonth(upwards: true)
        monthLabel.text = self.viewModel.monthForCalendarName
        title = String(self.viewModel.yearForCalendar)
        calendarCollectionView.reloadData()
    }
    
    @IBAction func moveToPreviousMonth(_ sender: UIButton) {
        viewModel.changeMonth(upwards: false)
        monthLabel.text = self.viewModel.monthForCalendarName
        title = String(self.viewModel.yearForCalendar)
        calendarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView {
            return viewModel.calendarDays.count
        }
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as? FullCalendarCell {
                let day = viewModel.calendarDays[indexPath.item]
                cell.dayLabel.text = String(Calendar.current.component(.day, from: day.date))
                let events = day.events
                if !events.isEmpty {
                    cell.eventsDot.isHidden = false
                }
                else {
                    cell.eventsDot.isHidden = true
                }
                if Calendar.current.isDate(day.date, inSameDayAs: Date()) {
                    cell.backgroundColor = .systemBlue
                    cell.dayLabel.layer.opacity = 1
                }
                else {
                    if day.isCurrentMonth {
                        cell.backgroundColor = .white
                        cell.dayLabel.layer.opacity = 1
                    }
                    else {
                        cell.backgroundColor = .systemGray5
                        cell.dayLabel.layer.opacity = 0.3
                    }
                }
                return cell
            }
            return UICollectionViewCell()
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Weekday", for: indexPath) as? WeekdaysForCalendarCell {
            cell.weekdayLabel.text = weekdaysShort[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DayDetail") as? DayDetailViewController {
                vc.date = viewModel.calendarDays[indexPath.item].date
                vc.events = viewModel.calendarDays[indexPath.item].events
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calendarCollectionView {
            let width = floor(collectionView.bounds.width / 7)
            let height = floor(collectionView.bounds.height / 6)
            return CGSize(width: width, height: height)
        }
        
        let width = floor(collectionView.bounds.width / 7)
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.calendarCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
}
