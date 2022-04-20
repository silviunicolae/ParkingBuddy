//
//  ParkingPlaces.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 06.11.2021.
//

import SwiftUI

struct ParkingPlaces: View {
    @StateObject var parkingVM = ParkingPlacesVM()
    
    @State var reloadView = true
    @State var showAddParking = false
    var body: some View {
        ZStack {
            if parkingVM.userHaveParkingPlaces {
                if parkingVM.userParkingPlaces.isEmpty {
                    LoadingViewTwoMainColor()
                } else {
                    ScrollView {
                        ForEach(parkingVM.userParkingPlaces) { place in
                            SellerParkingPlaceCard(place: place)
                        }
                    }
                }
            } else {
                Text(LocalizedStringKey("YouZeroParkingPlaces"))
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: AddParkingPlace()) {
                        BtnAddItem(image: "plus")
                            .padding(.bottom)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(LocalizedStringKey("ParkingSpots"))
        .background(Color("BgColor"))
        .onAppear(perform: {
            if self.reloadView {
                parkingVM.searchUserParkingPlaces()
                self.reloadView = false
            }
        })
    }
}

struct ParkingPlaces_Previews: PreviewProvider {
    static var previews: some View {
        ParkingPlaces()
        ParkingPlaces()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            .preferredColorScheme(.dark)
            
    }
}

struct SellerParkingPlaceCard: View {
    let place: SellerParkingPlace
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(place.adress)
                            .foregroundColor(place.isActive ? .black : .gray)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        HStack(alignment: .center, spacing: 20) {
                            ParkingSpotPrice(image: "timer", price: place.price_hour, currency: place.currency, per: "PricePerHour")
                            if place.price_day != 0 {
                                ParkingSpotPrice(image: "clock", price: place.price_day, currency: place.currency, per: "PricePerDay")
                            }
                        }
                    }
                    
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(place.isFree ? .green : .gray)
                        
                        if place.isElectric {
                            Image(systemName: "battery.100.bolt")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                HStack {
                    RoundWeekDay(day: "l", selected: place.parkingDayLuni)
                    RoundWeekDay(day: "m", selected: place.parkingDayMarti)
                    RoundWeekDay(day: "m", selected: place.parkingDayMiercuri)
                    RoundWeekDay(day: "j", selected: place.parkingDayJoi)
                    RoundWeekDay(day: "v", selected: place.parkingDayVineri)
                    RoundWeekDay(day: "s", selected: place.parkingDaySambata)
                    RoundWeekDay(day: "d", selected: place.parkingDayDuminica)
                }
            }
            .padding()
        }
        .modifier(BgWhiteShadowCornerRadius())
    }
}

struct RoundWeekDay: View {
    let day: String
    let selected: Bool
    var body: some View {
            Text("\(day.uppercased())")
                .font(.title3.bold())
                .foregroundColor(selected ? .white : .gray)
                .frame(width: 38, height: 38)
                .background(selected ? Color("MainColor") : .white)
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
    }
}
