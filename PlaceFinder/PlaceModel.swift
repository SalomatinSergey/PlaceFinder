//
//  PlaceModel.swift
//  PlaceFinder
//
//  Created by Sergey on 24.04.2022.
//

import Foundation
import UIKit

struct Place {
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var placeImage: String?
    
    static let restaurantNames = ["McDonalds",
                           "KFC",
                           "Burger King"]
    
    static func getPlaces() -> [Place] {
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Moscow", type: "Fast food",image: nil, placeImage: place))
        }
        return places
    }
}
