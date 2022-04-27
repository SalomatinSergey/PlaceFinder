//
//  MainViewController.swift
//  PlaceFinder
//
//  Created by Sergey on 23.04.2022.
//

import UIKit

class MainViewController: UITableViewController {

  //  var places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Table view data source    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return places.count
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            cell.textLabel?.text = places[indexPath.row].name
//            cell.imageView?.image = UIImage(named: places[indexPath.row].name)
//            cell.imageView?.layer.cornerRadius = cell.frame.size.height/2
//            cell.imageView?.clipsToBounds = true
//            return cell
//        }
       
//        let place = places[indexPath.row]
//        cell.nameLabel?.text = place.name
//        cell.locationLabel.text = place.location
//        cell.typeLabel.text = place.type
        
//        if place.image == nil {
//            cell.imageOfPlace?.image = UIImage(named: place.placeImage!)
//        } else {
//            cell.imageOfPlace.image = place.image
//        }
        
//        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
//        cell.imageOfPlace?.clipsToBounds = true
//        return cell
//    }
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
//
//        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
//
//        newPlaceVC.saveNewPlace()
//        places.append(newPlaceVC.newPlace!)
//        tableView.reloadData()
//    }

}
