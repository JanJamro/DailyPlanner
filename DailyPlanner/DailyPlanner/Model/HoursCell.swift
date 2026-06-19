//
//  HoursCell.swift
//  DailyPlanner
//
//  Created by Jan on 01/06/2026.
//

import UIKit

class HoursCell: UITableViewCell {
    @IBOutlet weak var hourStartLabel: UILabel!
    var previousEventlabel: UILabel?
    var eventLabelsCounter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in contentView.subviews {
            if view != hourStartLabel {
                view.removeFromSuperview()
            }
        }
    }
}
