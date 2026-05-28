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
    var currentDay: Int!
    var currentMonth: Int!
    var currentMonthName: String!
    var currentYear: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        weekdaysCollectionView.delegate = self
        weekdaysCollectionView.dataSource = self
        currentDay = viewModel.getCurrentDateParts().day
        currentMonth = viewModel.getCurrentDateParts().month
        currentMonthName = viewModel.getCurrentDateParts().monthName
        currentYear = viewModel.getCurrentDateParts().year
        
        title = String(currentYear)
        monthLabel.text = currentMonthName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        if let layout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }
        
        if let layout = weekdaysCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }
        calendarCollectionView.layer.borderWidth = 1
        calendarCollectionView.backgroundColor = .black
    }
    
    @objc func addEvent() {
        
    }
    
    @IBAction func moveToNextMonth(_ sender: UIButton) {
        
    }
    
    @IBAction func moveToPreviousMonth(_ sender: UIButton) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView {
            return 42
        }
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as? FullCalendarCell {
                cell.backgroundColor = .white
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
}
