//
//  StorageManager.swift
//  PlaceFinder
//
//  Created by Sergey on 27.04.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject (_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    static func deletObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
