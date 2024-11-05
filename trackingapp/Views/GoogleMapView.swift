//
//  GoogleMapView.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import SwiftUI
import GoogleMaps


struct GoogleMapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var showPath: Bool

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        if let currentLocation = locationManager.currentLocation {
            let marker = GMSMarker(position: currentLocation.coordinate)
            marker.map = mapView
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                                  longitude: currentLocation.coordinate.longitude,
                                                  zoom: 20)
            mapView.camera = camera
        }
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        guard let location = locationManager.currentLocation else { return }
                
        addMarker(mapView, location)
//         Draw path if showPath is enabled
        if showPath {
            let path = GMSMutablePath()
            for loc in locationManager.locationHistory {
                path.add(loc.coordinate)
            }
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 3.0
            polyline.map = mapView
        } else {
            addMarker(mapView, location)
        }
    }
    
    private func addMarker(_ mapView: GMSMapView, _ location: CLLocation) {
        mapView.clear() // This removes all markers and polylines; add only the latest marker back
        let marker = GMSMarker(position: location.coordinate)
        marker.icon = UIImage(systemName: "car") ?? GMSMarker.markerImage(with: .red)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
}
