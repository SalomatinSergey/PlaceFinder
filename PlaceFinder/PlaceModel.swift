//
//  PlaceModel.swift
//  PlaceFinder
//
//  Created by Sergey on 24.04.2022.
//

import RealmSwift

class Place: Object {
        
    @Persisted var name = ""
    @Persisted var location: String?
    @Persisted var type: String?
    @Persisted var imageData: Data?
    @Persisted var placeImage: String?
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
