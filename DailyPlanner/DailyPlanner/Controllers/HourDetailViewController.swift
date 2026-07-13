//
//  HourDetailViewController.swift
//  DailyPlanner
//
//  Created by Jan on 20/06/2026.
//

import UIKit

class HourDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var hourStartLabel: UILabel!
    @IBOutlet weak var hourEndLabel: UILabel!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var noEventsLabel: UILabel!
    var day: String!
    var hourDetail: HourDetail!
    var dayVC: DayDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = day
        hourStartLabel.text = hourDetail.hour
        let endHour = String(Int(hourDetail.hour.dropLast(3))! + 1)
        hourEndLabel.text = "\(endHour):00"
        
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(hourDetail.events.count)
        
        if hourDetail.events.isEmpty {
            eventsCollectionView.isHidden = true
            noEventsLabel.isHidden = false
        }
        else {
            eventsCollectionView.reloadData()
            eventsCollectionView.isHidden = false
            noEventsLabel.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourDetail.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourEvent", for: indexPath) as? HourEventsCell {
            if let image = UIImage(systemName: hourDetail.events[indexPath.row].eventType!.iconName!) {
                cell.eventImageView.image = image
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController {
            vc.event = hourDetail.events[indexPath.item]
            vc.hourVC = self
            if let dayVC = dayVC {
                vc.dayVC = dayVC
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
