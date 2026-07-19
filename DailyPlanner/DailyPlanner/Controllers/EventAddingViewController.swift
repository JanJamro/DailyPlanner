//
//  EventManagementViewController.swift
//  DailyPlanner
//
//  Created by Jan on 02/06/2026.
//

import UIKit
import PhotosUI

class EventAddingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var categorySelectionButton: UIButton!
    @IBOutlet weak var photoAddingButton: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    var viewModel: EventAddingViewModel!
    var titleText: String!
    var photoFileName: String?
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
        if let photoFileName = photoFileName {
            viewModel.imagePath = photoFileName
        }
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
        let alert = UIAlertController(title: "Add photo from:", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            if let photoFileName = viewModel.savePhotoOnDeviceAndReturnFileName(image: image) {
                self.photoFileName = photoFileName
                self.photoAddingButton.setTitle("Photo added", for: .normal)
                print("Photo added")
            }
        }
        
        dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let result = results.first {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            if let photoFileName = self?.viewModel.savePhotoOnDeviceAndReturnFileName(image: image) {
                                self?.photoFileName = photoFileName
                                self?.photoAddingButton.setTitle("Photo added", for: .normal)
                            }
                        }
                    }
                }
            }
        }
        
        dismiss(animated: true)
    }
}
