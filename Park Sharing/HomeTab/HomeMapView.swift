//
//  HomeMapView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import SwiftUI
import MapKit

struct HomeMapView: View {
    @StateObject private var mapVM = HomeMapViewModel()
    @Binding var showParkSpotInfo: Bool
    @Binding var parkSpotId: String
    @Binding var isElectric: Bool
    @Binding var is24h: Bool
    
    var body: some View {
        Map(coordinateRegion: $mapVM.region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: mapVM.availableParkingSpots) { parkingSpot in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: parkingSpot.latitude, longitude: parkingSpot.longitude)) {
                CustomMapPin(parkingSpot: parkingSpot)
                    .onTapGesture {
                        parkSpotId = parkingSpot.parkID
                        isElectric = parkingSpot.electric
                        is24h = parkingSpot.is24h
                        showParkSpotInfo.toggle()
                    }
            }
        }
            .ignoresSafeArea()
            .accentColor(.pink)
            .onAppear(perform: {
                mapVM.checkIfLocationServicesIsEnabled()
            })
            .alert(isPresented: $mapVM.permissionDenied, content: {
                Alert(title: Text(LocalizedStringKey("ErrorNoLocation")), message: Text(LocalizedStringKey("ErrorNoLocationMsg")), dismissButton: .default(Text(LocalizedStringKey("GoToSettings")), action: {
                    // Redirecting to Setting
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
            })
    }
}

struct HomeMapView_Previews: PreviewProvider {
    @State static var show = false
    @State static var parkSpotDetails = ""
    @State static var isElectric = false
    @State static var is24h = false
    static var previews: some View {
        HomeMapView(showParkSpotInfo: $show, parkSpotId: $parkSpotDetails, isElectric: $isElectric, is24h: $is24h)
    }
}
