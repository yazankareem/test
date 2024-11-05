//
//  AppDelegate.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import Foundation
import UIKit
import GoogleMaps
import FirebaseCore
import GooglePlaces

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Provide the Google Maps API Key here
        FirebaseApp.configure()
        GMSServices.provideAPIKey("Add your key here")
        GMSPlacesClient.provideAPIKey("Add your key here")
        GMSServices.provideAPIKey("Add your key here")
        return true
    }
}
