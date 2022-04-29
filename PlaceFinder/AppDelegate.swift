//
//  AppDelegate.swift
//  PlaceFinder
//
//  Created by Sergey on 23.04.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
            schemaVersion: 2, // Set the new schema version.
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // The enumerateObjects(ofType:_:) method iterates over
                    // every Person object stored in the Realm file to apply the migration
//                    migration.enumerateObjects(ofType: Person.className()) { oldObject, newObject in
//                        // combine name fields into a single field
//                        let firstName = oldObject!["firstName"] as? String
//                        let lastName = oldObject!["lastName"] as? String
//                        newObject!["fullName"] = "\(firstName!) \(lastName!)"
//                    }
                }
            }
        )
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}
