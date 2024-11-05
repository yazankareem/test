//
//  LocationManager.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? // To store the latest location
    @Published var locationHistory: [CLLocation] = [] // For storing a path of locations
    @Published var isTracking = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // Request authorization to track location even in the background
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationHistory.append(contentsOf: LocationUserModel.retrieveLocationHistory())
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation() // Start getting location updates
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation() // Stop getting location updates
    }
    
    // Delegate method that receives location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        
        if userIsStationary(latestLocation) {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 500  // meters
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10  // meters
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation = latestLocation
        }
        if !isTracking {
            stopTracking()
        } else {
            locationHistory.append(latestLocation)
        }
        
        saveLocalData(locationHistory)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startTracking()
        }
    }
    
    private func userIsStationary(_ location: CLLocation?) -> Bool {
        // Your logic to determine if the user is stationary
        // For example, check if speed is below a certain threshold
        return location?.speed ?? 0 < 0.5
    }
    
    private func saveLocalData(_ location:  [CLLocation]) {
        LocationUserModel.saveLocationHistory(locations: location)
    }
}
