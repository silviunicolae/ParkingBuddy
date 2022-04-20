//
//  HomeParkingSpotDetails.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import SwiftUI



struct HomeParkingSpotDetails: View {
    @StateObject var homeVM = HomeTabViewModel()
    
    @Binding var showParkSpotInfo: Bool
    @Binding var parkSpotId: String
    var isElectric: Bool
    var is24h: Bool
    
    var body: some View {
        ZStack {
            ParkingSpotDetailsBG()
                .ignoresSafeArea()
                .onTapGesture {
                    showParkSpotInfo.toggle()
                }
            
            ParkingSpotDetailsCard(parkDetails: homeVM.parkDetails, parkSpotDetails: $parkSpotId, isElectric: isElectric, isLoading: $homeVM.isLoading, is24h: is24h)
                .onAppear(perform: {
                    homeVM.getParkingSpotDetails(parkID: parkSpotId)
                })
        }
    }
}

struct HomeParkingSpotDetails_Previews: PreviewProvider {
    @State static var show = false
    @State static var parkSpotDetails = "LOC DE PARCARE"
    static var previews: some View {
        HomeParkingSpotDetails(showParkSpotInfo: $show, parkSpotId: $parkSpotDetails, isElectric: true, is24h: true)
    }
}

struct ParkingSpotDetailsBG: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(.gray.opacity(0.5))
    }
}

struct ParkingSpotDetailsCard: View {
    var parkDetails: ParkingSpotDetails
    @Binding var parkSpotDetails: String
    var isElectric: Bool
    @Binding var isLoading: Bool
    var is24h: Bool
    @State var showBigPhoto = false
    
    let price_hour = 1000
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                if isLoading {
                    VStack {
                        HStack {
                            Spacer()
                            LoadingViewTwoMainColor()
                            Spacer()
                        }
                    }.frame(height: 306)
                    
                } else {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                        
                        VStack(alignment: .leading) {
                            Text(parkDetails.address)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                            Text(parkDetails.seller_name)
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                        Spacer()
                        if isElectric {
                            Image(systemName: "battery.100.bolt")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 35)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    
                    AsyncImageView(img_url: parkDetails.img)
                        .scaledToFit()
                        .frame(height: 100)
                        .onTapGesture {
                            showBigPhoto.toggle()
                        }
                        .sheet(isPresented: $showBigPhoto) {
                            BigPhotoView(img: parkDetails.img)
                        }
                    
                    HStack(spacing: 20) {
                        ParkingSpotPrice(image: "timer", price: parkDetails.price_hour, currency: parkDetails.currency, per: "PricePerHour")
                        if is24h != false {
                            if parkDetails.price_day != 0 {
                                ParkingSpotPrice(image: "clock", price: parkDetails.price_day, currency: parkDetails.currency, per: "PricePerDay")
                            }
                        }
                    }
                    
                    Button(action: {
                        print("inchirieaza")
                    }) {
                        HStack {
                            Spacer()
                            Text("Închirează")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .background(isElectric ? .green : Color("MainColor"))
                }
            }
            .background(.white)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 30)
            .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
        }
    }
}

struct ParkingSpotPrice: View {
    var image: String
    var price: Double
    var currency: String
    var per: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("MainColor"))
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    Text("\(price, specifier: "%.2f")")
                        .fontWeight(.semibold)
                    Text(currency)
                        .fontWeight(.semibold)
                }
                Text(per)
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
}
