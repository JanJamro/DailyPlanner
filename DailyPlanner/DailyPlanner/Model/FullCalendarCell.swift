//
//  FullCalendarCell.swift
//  DailyPlanner
//
//  Created by Jan on 28/05/2026.
//

import UIKit

class FullCalendarCell: UICollectionViewCell {
    @IBOutlet weak var eventsStackView: UIStackView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        eventsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
