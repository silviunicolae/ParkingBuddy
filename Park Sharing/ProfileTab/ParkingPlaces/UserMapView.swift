//
//  UserMapView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 06.11.2021.
//

import SwiftUI
import MapKit

struct UserMapView: UIViewRepresentable {
    @EnvironmentObject var mapData: ParkingPlacesVM
    @Binding var centerCoordinate: CLLocationCoordinate2D
    func makeUIView(context: Context) -> MKMapView {
        let mapView = mapData.mapView
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UserMapView

        init(_ parent: UserMapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

