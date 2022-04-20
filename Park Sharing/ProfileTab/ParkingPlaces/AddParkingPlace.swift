//
//  AddParkingPlace.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 06.11.2021.
//

import SwiftUI
import MapKit
import CoreLocation
import PhotosUI

struct AddParkingPlace: View {
    @StateObject var parkingVM = ParkingPlacesVM()
    @State private var showParkingDetails = false
    var body: some View {
        ZStack {
            ZStack {
                UserMapView(centerCoordinate: $parkingVM.centerCoordinate)
                    .environmentObject(parkingVM)
                    .edgesIgnoringSafeArea(.top)
                //                Circle()
                //                    .frame(width: 30, height: 30, alignment: .center)
                //                    .foregroundColor(.red.opacity(0.5))
                Image(systemName: "mappin")
                    .frame(width: 30, height: 30, alignment: .center)
                    .offset(y: -9)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = parkingVM.centerCoordinate
                        parkingVM.location = newLocation
                        
                        //                        print("user location: \(parkingVM.locationManager?.location?.coordinate)")
                        //                        print("center location \(parkingVM.location.coordinate)")
                        
                        let newLatitude = String(newLocation.coordinate.latitude)
                        let newLongitude = String(newLocation.coordinate.longitude)
                        parkingVM.getAddressFromLatLon(pdblLatitude: newLatitude, withLongitude: newLongitude)
                        
                        showParkingDetails.toggle()
                    }) {
                        BtnAddItem(image: "plus")
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        parkingVM.updateMapType()
                    }) {
                        BtnAddItem(image: parkingVM.mapType == .standard ? "network" : "map")
                    }
                    .padding(.bottom)
                }
            }
            .padding()
            
            if parkingVM.hideLoading == false {
                FindingUserLocation()
            }
            
            if showParkingDetails {
                AddParkingSpotDetails(vm: parkingVM, showParkingDetails: $showParkingDetails)
            }
        }
        .onAppear(perform: {
            parkingVM.checkIfLocationServicesIsEnabled()
        })
        .alert(isPresented: $parkingVM.permissionDenied, content: {
            Alert(title: Text(LocalizedStringKey("ErrorNoLocation")), message: Text(LocalizedStringKey("ErrorNoLocationMsg")), dismissButton: .default(Text(LocalizedStringKey("GoToSettings")), action: {
                // Redirecting to Setting
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .alert(isPresented: $parkingVM.alert, content: {
            Alert(title: Text(LocalizedStringKey(parkingVM.alertTittle)), message: Text(LocalizedStringKey(parkingVM.alertMessage)), dismissButton: .destructive(Text("Ok"), action: {
            }))
        })
    }
}

struct AddParkingPlace_Previews: PreviewProvider {
    static var previews: some View {
        AddParkingPlace()
        AddParkingPlace()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}

struct FindingUserLocation: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                LoadingViewTwoWhite()
                Spacer()
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(.black.opacity(0.6))
    }
}

struct AddParkingSpotDetails: View {
    @ObservedObject var vm: ParkingPlacesVM
    @Binding var showParkingDetails: Bool
    var body: some View {
        ZStack {
            ParkingSpotDetailsBG()
                .edgesIgnoringSafeArea(.top)
            AddParkingSpotDetailsCard(vm: vm, showParkingDetails: $showParkingDetails)
        }
    }
}

struct AddParkingSpotDetailsCard: View {
    @ObservedObject var vm: ParkingPlacesVM
    @Binding var showParkingDetails: Bool
    
    @State private var priceDouble = ""
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text(vm.parkingAddress)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                ParkingCardPhoto(vm: vm)
                ParkingCardSelectDays(vm: vm)
                
                PriceTextField(placeholder: "AddPricePerHour", text: $vm.parkingHourPrice, currency: "PriceCurrency")
                    .keyboardType(.decimalPad)
                PriceTextField(placeholder: "AddPricePerDay", text: $vm.parkingDayPrice, currency: "PriceCurrency")
                    .keyboardType(.decimalPad)
                NormalTextField(placeholder: "PhoneNumber", text: $vm.parkingPhone)
                    .keyboardType(.phonePad)
                Toggle(vm.parkingIsElectric ? LocalizedStringKey("IsElectric") : LocalizedStringKey("NoElectric"), isOn: $vm.parkingIsElectric)
                    .toggleStyle(AddElectricToggleStyle())
                
                CustomTextEditor(placeholder: "DetailsField", text: $vm.parkingDetails)
                
                Button(action: {
                    withAnimation() {
                        vm.isSaving = 2
                    }
                    vm.addNewParkingSpot()
                    
                    _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                        if vm.isSaving == 3 {
                            withAnimation() {
                                showParkingDetails = false
                            }
                        }
                    }
                }) {
                    AddParkingSpotButton(number: $vm.isSaving)
                }
                .frame(width: (UIScreen.main.bounds.width / 2), height: 40)
                .modifier(BtnMainColorBackground())
                .disabled(vm.isSaving == 2)
                .disabled(vm.isSaving == 3)
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 30)
            .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct AddParkingSpotButton: View {
    @Binding var number: Int
    var body: some View {
        if number == 1 {
            Text(LocalizedStringKey("AddParkingSpot"))
                .font(.title3)
                .fontWeight(.semibold)
        } else if number == 2 {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        } else if number == 3 {
            Text(LocalizedStringKey("SuccesTitle"))
                .font(.title3)
                .fontWeight(.semibold)
        } else if number == 4 {
            Text(LocalizedStringKey("ErrorTitle"))
                .foregroundColor(.red)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}

struct ParkingCardPhoto: View {
    @ObservedObject var vm: ParkingPlacesVM
    @State var sellectPhoto: Bool = false
    @State var pickerResult: [UIImage] = []
    var config: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images //videos, livePhotos...
        config.selectionLimit = 1
        return config
    }
    var body: some View {
        Button(action: {
            sellectPhoto.toggle()
        }){
            ZStack(alignment: .bottomTrailing) {
                if pickerResult.isEmpty {
                    Image("profileIMG")
                        .resizable()
                        .modifier(RoundPhoto())
                } else {
                    ForEach( pickerResult, id: \.self) { image in
                        Image.init(uiImage: image)
                            .resizable()
                            .modifier(RoundPhoto())
                    }
                }
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
            }
            .sheet(isPresented: $sellectPhoto) {
                UserPhotoPicker(configuration: self.config, pickerResult: $pickerResult, isPresented: $sellectPhoto, photosForUpload: $vm.parkingPicture)
            }
        }
    }
}
struct ParkingCardSelectDays: View {
    @ObservedObject var vm: ParkingPlacesVM
    var body: some View {
        VStack {
            HStack {
                BtnWeekDay(day: "l", selected: $vm.parkingDayLuni)
                BtnWeekDay(day: "m", selected: $vm.parkingDayMarti)
                BtnWeekDay(day: "m", selected: $vm.parkingDayMiercuri)
                BtnWeekDay(day: "j", selected: $vm.parkingDayJoi)
                BtnWeekDay(day: "v", selected: $vm.parkingDayVineri)
                BtnWeekDay(day: "s", selected: $vm.parkingDaySambata)
                BtnWeekDay(day: "d", selected: $vm.parkingDayDuminica)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 12) {
                if vm.parkingDayLuni {
                    ParkingCardSelectHours(day: "DayLuni", fromH: $vm.luniFrom, toH: $vm.luniTo)
                }
                if vm.parkingDayMarti {
                    ParkingCardSelectHours(day: "DayMarti", fromH: $vm.martiFrom, toH: $vm.martiTo)
                }
                if vm.parkingDayMiercuri {
                    ParkingCardSelectHours(day: "DayMiercuri", fromH: $vm.miercuriFrom, toH: $vm.miercuriTo)
                }
                if vm.parkingDayJoi {
                    ParkingCardSelectHours(day: "DayJoi", fromH: $vm.joiFrom, toH: $vm.joiTo)
                }
                if vm.parkingDayVineri {
                    ParkingCardSelectHours(day: "DayVineri", fromH: $vm.vineriFrom, toH: $vm.vineriTo)
                }
                if vm.parkingDaySambata {
                    ParkingCardSelectHours(day: "DaySambata", fromH: $vm.sambataFrom, toH: $vm.sambataTo)
                }
                if vm.parkingDayDuminica {
                    ParkingCardSelectHours(day: "DayDuminica", fromH: $vm.duminicaFrom, toH: $vm.duminicaTo)
                }
            }
        }
    }
}

struct BtnWeekDay: View {
    let day: String
    @Binding var selected: Bool
    var body: some View {
        Button(action: {
            withAnimation(.easeIn) {
                self.selected.toggle()
            }
        }) {
            Text("\(day.uppercased())")
                .font(.title3.bold())
                .foregroundColor(selected ? .white : .gray)
                .frame(width: 38, height: 38)
                .background(selected ? Color("MainColor") : .white)
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
        }
    }
}

struct ParkingCardSelectHours: View {
    let day: LocalizedStringKey
    @Binding var fromH: Date
    @Binding var toH: Date
    @State var allDay = false
    var body: some View {
        HStack {
            Text(day)
                .lineLimit(1)
                .foregroundColor(.gray)
                .padding(.leading)
            
            Spacer()
            
            ParkingSelectHoursCard(type: "HourFrom", hour: $fromH)
            
            ParkingSelectHoursCard(type: "HourTo", hour: $toH)
            
            Button(action: {
                withAnimation(.easeIn) {
                    self.allDay.toggle()
                    
                    var components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
                    components.hour = 0
                    components.minute = 0
                    self.fromH = Calendar.current.date(from: components) ?? Date.now
                    var componentsT = DateComponents()
                    componentsT.hour = 23
                    componentsT.minute = 59
                    self.toH = Calendar.current.date(from: componentsT) ?? Date.now
                }
            }) {
                Text("24h")
                    .font(.subheadline)
                    .foregroundColor(self.allDay ? .white : .gray)
                    .frame(width: 32, height: 32)
                    .background(self.allDay ? Color("MainColor") : .white)
                    .clipShape(Circle())
                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
            }
        }
    }
}

struct ParkingSelectHoursCard: View {
    let type: LocalizedStringKey
    @Binding var hour: Date
    var body: some View {
        ZStack {
            Text(type)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .background(.clear)
                .cornerRadius(5)
                .offset(y: -25)
                .scaleEffect(0.9, anchor: .leading)
            
            DatePicker(type, selection: $hour, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .foregroundColor(.black)
        .padding(.vertical, 5)
        .frame(width: 100, height: 40)
    }
}

//CustomDatePicker(selection: $wakeUp, minuteInterval: 15, displayedComponents: .hourAndMinute)
//struct CustomDatePicker: UIViewRepresentable {
//
//    @Binding var selection: Date
//    let minuteInterval: Int
//    let displayedComponents: DatePickerComponents
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<MyDatePicker>) -> UIDatePicker {
//        let picker = UIDatePicker()
//        // listen to changes coming from the date picker, and use them to update the state variable
//        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
//        return picker
//    }
//
//    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyDatePicker>) {
//        picker.minuteInterval = minuteInterval
//        picker.date = selection
//
//        switch displayedComponents {
//        case .hourAndMinute:
//            picker.datePickerMode = .time
//        case .date:
//            picker.datePickerMode = .date
//        case [.hourAndMinute, .date]:
//            picker.datePickerMode = .dateAndTime
//        default:
//            break
//        }
//    }
//
//    class Coordinator {
//        let datePicker: MyDatePicker
//        init(_ datePicker: MyDatePicker) {
//            self.datePicker = datePicker
//        }
//
//        @objc func dateChanged(_ sender: UIDatePicker) {
//            datePicker.selection = sender.date
//        }
//    }
//}
