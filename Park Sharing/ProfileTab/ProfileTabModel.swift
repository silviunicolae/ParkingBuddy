//
//  ProfileTabModel.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 31.10.2021.
//

import SwiftUI

struct ProfileOptionItem: Identifiable {
    var id = UUID()
    var icon: String
    var name: LocalizedStringKey
    var destination: AnyView
}


// MARK: - Profile Option Items Data
let userItems = [
    ProfileOptionItem(icon: "car", name: "MyCars", destination: AnyView(MyCarsView())),
    ProfileOptionItem(icon: "creditcard", name: "PaymentMethods", destination: AnyView(EmptyView())),
]

let sellerItems = [
    ProfileOptionItem(icon: "location", name: "ParkingSpots", destination: AnyView(ParkingPlaces())),
    ProfileOptionItem(icon: "creditcard.and.123", name: "MoneyMade", destination: AnyView(EmptyView()))
]

let generalItems = [
    ProfileOptionItem(icon: "bell", name: "AppNotifications", destination: AnyView(EmptyView())),
    ProfileOptionItem(icon: "gearshape", name: "AppSettings", destination: AnyView(EmptyView())),
    ProfileOptionItem(icon: "latch.2.case", name: "AppSupport", destination: AnyView(EmptyView()))
]
