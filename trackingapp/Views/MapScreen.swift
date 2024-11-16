//
//  MapScreen.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import SwiftUI
import GoogleMaps
import FirebaseAuth

struct MapScreen: View {
    @Environment(\.keychain) var keychain
    @EnvironmentObject var authManager: AuthManager
    @State private var showPath = false
    @State private var showPreviousLogins = false
    @State private var showConfirmationDialog = false
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack {
            // Google Map View embedded within SwiftUI
            GoogleMapView(showPath: $showPath)
                .edgesIgnoringSafeArea(.all)
                .environmentObject(locationManager)
            
            HStack {
                // Toggle for movement path
                Toggle("Show Path", isOn: $showPath)
                    .padding()
                
                Spacer()

                // Previous logins button
                Button(action: {
                    showPreviousLogins = true
                }) {
                    Text("Previous Logins")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .background(Color.white.opacity(0.8))

            HStack {
                // Start/Stop Tracking Button
                Button(action: {
                    locationManager.isTracking.toggle()
                    if locationManager.isTracking {
                        locationManager.startTracking()
                    } else {
                        locationManager.stopTracking()
                    }
                }) {
                    Text(locationManager.isTracking ? "Stop Tracking" : "Start Tracking")
                        .foregroundColor(.white)
                        .padding()
                        .background(locationManager.isTracking ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Logout button
                
                Button(action: {
                    showConfirmationDialog.toggle()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .sheet(isPresented: $showPreviousLogins) {
                PreviousLoginsView() // A separate view showing previous login emails
            }
        }
        .navigationBarBackButtonHidden(true)
        .confirmationDialog("Are you sure you want to signOut?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("signOut", role: .destructive) {
                authManager.signOut { error in
                    print("signOut: \(error?.localizedDescription ?? "")")
                }
            }
            Button("Cancel", role: .cancel) {
                // Do nothing, just dismiss
            }
        }
    }
}

#Preview {
    MapScreen()
}
