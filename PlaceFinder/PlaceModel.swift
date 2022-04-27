//
//  PlaceModel.swift
//  PlaceFinder
//
//  Created by Sergey on 24.04.2022.
//

import RealmSwift

class Place: Object {
        
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var placeImage: String?
    
    let restaurantNames = ["McDonalds",
                           "KFC",
                           "Burger King"]
    
    func savePlaces() {
        
        for place in restaurantNames {
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "Moscow"
            newPlace.type = "Cafe"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
    }
}
}
