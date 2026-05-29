//
//  DayDetailViewController.swift
//  DailyPlanner
//
//  Created by Jan on 29/05/2026.
//

import UIKit

class DayDetailViewController: UIViewController {
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        title = dateFormatter.string(from: date)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
    }
    
    @objc func addEvent() {
        
    }
}
