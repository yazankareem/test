//
//  LocationUserModel.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import Foundation
import RealmSwift
import CoreLocation
import FirebaseAuth

class LocationUserModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userID: String
    @Persisted var locations = List<LocationObjectModel>()

    var arraylocations: [LocationObjectModel] {
        Array(locations)
    }
    
    
   static func saveLocationHistory(locations: [CLLocation]) {
        let realm = try! Realm()
        
        let locationHistory = LocationUserModel()
        locationHistory.userID = Auth.auth().currentUser?.uid ?? ""
        locationHistory.locations.append(objectsIn: locations.map { LocationObjectModel(location: $0) })
        
        try! realm.write {
            realm.add(locationHistory, update: .modified)
        }
        
        print("Location history saved to Realm.")
    }
    
    static func retrieveLocationHistory() -> [CLLocation] {
        let realm = try! Realm()
        
        if let locationHistory = realm.objects(LocationUserModel.self).filter("userID == %@", Auth.auth().currentUser?.uid ?? "").first {
            return locationHistory.locations.map { $0.toCLLocation() }
        } else {
            return []
        }
    }
}
