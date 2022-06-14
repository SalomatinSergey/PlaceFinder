//
//  NewPlaceViewController.swift
//  PlaceFinder
//
//  Created by Sergey on 26.04.2022.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var imageIsChanged = false
    var currentPlace: Place?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var ratingControl: Rating!
    @IBOutlet weak var routeToAdress: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
//                                                         width: tableView.frame.size.width,
//                                                         height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        routeToAdress.isHidden = true
        placeLocation.addTarget(self, action: #selector(textFieldNotEmpty), for: .editingChanged)
        
        setupEditScreen()
    
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "image")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            
            camera.setValue(cameraIcon.resizeImageTo(size: CGSize(width: 30, height: 30)), forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
           
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            
            photo.setValue(photoIcon.resizeImageTo(size: CGSize(width: 30, height: 30)), forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
              let mapVC = segue.destination as? MapViewController
        else { return }
        
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        
        if identifier == "showPlace" {
            
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text
            mapVC.place.type = placeType.text
            mapVC.place.imageData = placeImage.image?.pngData()
        }
    }
    
    func savePlace() {
        
        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "empty_location")
        let imageData = image?.pngData()
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: ratingControl.rating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
        
    }
    
    /// Assign values ​​to outlets according to the selected cells
    private func setupEditScreen() {
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.contentMode = .scaleAspectFit
            placeImage.image = image
            placeType.text = currentPlace?.type
            placeLocation.text = currentPlace?.location
            placeName.text = currentPlace?.name
            ratingControl.rating = (currentPlace?.rating)!
        }
        
        if placeLocation.text?.isEmpty == false {
            routeToAdress.isHidden = false
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // return the keyboard by pressing tap "done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func textFieldNotEmpty() {
        if placeLocation.text?.isEmpty == false {
            routeToAdress.isHidden = false
        } else {
            routeToAdress.isHidden = true
        }
    }
}

// MARK: - work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Choose image with imagePickerController
    /// - Parameter sourse: checking the availability of the source
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
            
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Resize image
extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension NewPlaceViewController: MapViewControllerDelegate {
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
}
