//
//  HomeTabVM.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import Foundation
import Parse
import SwiftUI

final class HomeTabViewModel: ObservableObject {
    @Published var parkDetails = ParkingSpotDetails(seller_name: "", address: "", price_hour: 0, price_day: 0, currency: "", img: "")
    @Published var isLoading = true
    
    func getParkingSpotDetails(parkID: String) {
        let query = PFQuery(className: "ParkingSpots")
        query.includeKey("currency")
        query.includeKey("seller")
        
        query.getObjectInBackground(withId: parkID) { (object, error) in
            if let error = error {
                print("eroare citire detalii loc de parcare")
                print(error.localizedDescription)
                return
            } else {
                if let object = object {
                    let seller_obj = object["seller"] as! PFObject
                    self.parkDetails.seller_name = seller_obj["username"] as! String
                    self.parkDetails.address = object["address"] as! String
                    self.parkDetails.price_hour = object["price_hour"] as! Double
                    self.parkDetails.price_day = object["price_day"] as? Double ?? 0
                    let currency_obj = object["currency"] as! PFObject
                    self.parkDetails.currency = currency_obj["currency"] as! String
                    
                    let poza_main = object["picture"] as? PFFileObject
                    self.parkDetails.img = poza_main?.url ?? ""
                    
                    self.isLoading = false
                }
            }
        }
    }
    
}
