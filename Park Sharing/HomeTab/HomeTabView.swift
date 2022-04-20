//
//  HomeTabView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 27.10.2021.
//

import SwiftUI

struct HomeTabView: View {
    @State var showParkSpotInfo = false
    @State var parkSpotId = ""
    @State var isElectric = false
    @State var is24h = false
    var body: some View {
        ZStack {
            
            HomeMapView(showParkSpotInfo: $showParkSpotInfo, parkSpotId: $parkSpotId, isElectric: $isElectric, is24h: $is24h)
            
            if showParkSpotInfo {
                withAnimation() {
                    HomeParkingSpotDetails(showParkSpotInfo: $showParkSpotInfo, parkSpotId: $parkSpotId, isElectric: isElectric, is24h: is24h)
                }
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
