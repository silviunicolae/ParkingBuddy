//
//  CustomMapPin.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import SwiftUI

struct CustomMapPin: View {
    var parkingSpot: ParkingSpots
    
    var body: some View {
        Image(systemName: parkingSpot.electric ? "bolt.car.circle.fill" : "car.circle.fill")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(parkingSpot.electric ? .mint : .cyan)
    }
}

//struct CustomMapPin_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomMapPin()
//    }
//}
