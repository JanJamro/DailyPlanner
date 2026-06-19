//
//  EventManagementViewController.swift
//  DailyPlanner
//
//  Created by Jan on 02/06/2026.
//

import UIKit

class EventAddingViewController: UIViewController {
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var categorySelectionButton: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    var viewModel: EventAddingViewModel!
    var titleText: String!
    var startDate: Date? {
        didSet {
            if endDate != nil {
                if endDate! <= startDate! {
                    endDate = startDate! + 60
                }
            }
            else {
                endDate = startDate! + 60
            }
        }
    }
    var endDate: Date?
    weak var dayVC: DayDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventAddingViewModel(startDate: startDate)
        title = titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEvent))
        if let startDate = startDate {
            endDate = startDate + 60
            startDatePicker.date = startDate
            endDatePicker.date = endDate!
        }
        else {
            startDate = startDatePicker.date
            endDate = endDatePicker.date
        }
        
        startDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        let categories = viewModel.getEventTypes()
        var actions: [UIMenuElement] = []
        for category in categories {
            let action = UIAction(title: category) { _ in }
            actions.append(action)
        }
        categorySelectionButton.menu = UIMenu(children: actions)
    }
    
    @objc func saveEvent() {
        viewModel.startDate = startDate!
        viewModel.endDate = endDate!
        viewModel.description = descriptionTextView.text
        viewModel.categoryName = categorySelectionButton.currentTitle
        viewModel.address = locationAddressLabel.text
        //lat,long,imgpath do dorobienia
        viewModel.createEvent()
        if let dayVC = dayVC {
            dayVC.fetchNeeded = true;
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        startDate = startDatePicker.date
        endDate = endDatePicker.date
        if sender == startDatePicker {
            if endDate != nil {
                if endDate! <= startDate! {
                    endDate = startDate! + 60
                }
            }
            else {
                endDate = startDate! + 60
            }
            endDatePicker.date = endDate!
        }
        else {
            if startDate! > endDate! {
                startDate = endDate! - 60
                
            }
        }
        startDatePicker.date = startDate!
        endDatePicker.date = endDate!
    }
    
    @IBAction func pickLocation(_ sender: UIButton) {
        
    }
    
    @IBAction func photosAdding(_ sender: UIButton) {
        
    }
}
