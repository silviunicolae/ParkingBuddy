//
//  MapModel.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import Foundation

struct ParkingSpots: Identifiable {
    var id = UUID()
    var parkID :String
    let latitude: Double
    let longitude: Double
    let electric: Bool
    let is24h: Bool
}
