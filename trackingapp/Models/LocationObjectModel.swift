//
//  LocationObjectModel.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import Foundation
import RealmSwift
import CoreLocation

class LocationObjectModel: Object, ObjectKeyIdentifiable, Decodable {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var altitude: Double
    @Persisted var horizontalAccuracy: Double
    @Persisted var verticalAccuracy: Double
    @Persisted var timestamp: Date
    
    // Initializer to create a LocationObjectModel from a CLLocation
    convenience init(location: CLLocation) {
        self.init()
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.timestamp = location.timestamp
    }
    
    // Function to convert LocationObject back to CLLocation
    func toCLLocation() -> CLLocation {
        return CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            timestamp: timestamp
        )
    }
}
