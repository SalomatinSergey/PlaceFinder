//
//  MainViewController.swift
//  PlaceFinder
//
//  Created by Sergey on 23.04.2022.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)

    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = places[indexPath.row].name
            cell.imageView?.image = UIImage(named: places[indexPath.row].name)
            cell.imageView?.layer.cornerRadius = cell.frame.size.height/2
            cell.imageView?.clipsToBounds = true
            return cell
        }
       
        let place = places[indexPath.row]
        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
       
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace?.clipsToBounds = true
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            StorageManager.deletObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController // swiftlint:disable:this force_cast
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }

        newPlaceVC.savePlace()
        tableView.reloadData()
    }

}
