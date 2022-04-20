//
//  ParkingPlacesModel.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 24.11.2021.
//

import Foundation

struct SellerParkingPlace: Identifiable {
    let id = UUID()
    let parkID: String
    let isActive: Bool
    let isFree: Bool
    let isElectric: Bool
    let adress: String
    let price_hour: Double
    let price_day: Double
    let currency: String
    var parkingDayLuni: Bool
    var parkingDayMarti: Bool
    var parkingDayMiercuri: Bool
    var parkingDayJoi: Bool
    var parkingDayVineri: Bool
    var parkingDaySambata: Bool
    var parkingDayDuminica: Bool
}
