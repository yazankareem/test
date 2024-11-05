//
//  trackingappApp.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import SwiftUI

@main
struct trackingappApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthManager()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authManager.isUserLoggedIn {
                    MapScreen()
                        .environmentObject(authManager)
                        .environmentObject(locationManager)
                } else {
                    LoginScreen()
                        .environmentObject(authManager)
                }
            }
        }
    }
}
