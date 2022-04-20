//
//  ParkingPlacesVM.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 06.11.2021.
//

import SwiftUI
import Parse
import MapKit
import CoreLocation

final class ParkingPlacesVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var userParkingPlaces = [SellerParkingPlace]()
    @Published var userHaveParkingPlaces = true
    
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var location = MKPointAnnotation()
    
    @Published var permissionDenied = false
    @Published var mapView = MKMapView()
    @Published var region: MKCoordinateRegion!
    @Published var hideLoading = false
    @Published var mapType: MKMapType = .standard
    
    // parking spot information
    //    @Published var parkingAddress: String = "Strada Cernăuți 47, Timișoara, Romania, 300362"
    @Published var parkingAddress: String = ""
    @Published var parkingCity: String = ""
    @Published var parkingCountry: String = ""
    @Published var parkingPicture = [UIImage]()
    @Published var parkingHourPrice = ""
    @Published var parkingDayPrice = ""
    @Published var parkingPhone = ""
    @Published var parkingIsElectric = false
    @Published var parkingDetails = ""
    @Published var finalLatitude: Double = 0
    @Published var finalLongitude: Double = 0
    
    // parking Days and Hours
    @Published var parkingDayLuni: Bool = false
    @Published var parkingDayMarti: Bool = false
    @Published var parkingDayMiercuri: Bool = false
    @Published var parkingDayJoi: Bool = false
    @Published var parkingDayVineri: Bool = false
    @Published var parkingDaySambata: Bool = false
    @Published var parkingDayDuminica: Bool = false
    @Published var luniFrom: Date = Date()
    @Published var luniTo: Date = Date()
    @Published var martiFrom: Date = Date()
    @Published var martiTo: Date = Date()
    @Published var miercuriFrom: Date = Date()
    @Published var miercuriTo: Date = Date()
    @Published var joiFrom: Date = Date()
    @Published var joiTo: Date = Date()
    @Published var vineriFrom: Date = Date()
    @Published var vineriTo: Date = Date()
    @Published var sambataFrom: Date = Date()
    @Published var sambataTo: Date = Date()
    @Published var duminicaFrom: Date = Date()
    @Published var duminicaTo: Date = Date()
    
    // Error Alerts
    @Published var alert = false
    @Published var alertTittle = ""
    @Published var alertMessage = ""
    @Published var isSaving = 1
    
    func searchUserParkingPlaces() {
        let currentUser = PFUser.current()
        self.userParkingPlaces.removeAll()
        let query = PFQuery(className: "ParkingSpots")
        query.whereKey("seller", equalTo: currentUser!)
        query.includeKey("currency")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print("eroare cautare locuri de parcare user")
                print(error.localizedDescription)
                self.userHaveParkingPlaces = false
                return
            } else {
                if let returnedObjects = objects {
                    for object in returnedObjects {
                        let parkID = object.objectId!
                        let isActive = object["is_Active"] as? Bool ?? false
                        let rentedUntil = object["rented_until"] as? Date ?? Date()
                        var isFree = true
                        if rentedUntil > Date.now {
                            isFree = false
                        }
                        if isActive == false {
                            isFree = false
                        }
                        let isElectric = object["is_electric"] as? Bool ?? false
                        let adress = object["address"] as! String
                        let price_hour = object["price_hour"] as? Double ?? 0
                        let price_day = object["price_day"] as? Double ?? 0
                        let currency_obj = object["currency"] as! PFObject
                        let currency = currency_obj["currency"] as! String
                        
                        var parkingDayLuni = false
                        let isLuni = object["LuniFrom"] as? Double ?? 30
                        if isLuni != 30 {
                            parkingDayLuni = true
                        }
                        var parkingDayMarti = false
                        let isMarti = object["MartiFrom"] as? Double ?? 30
                        if isMarti != 30 {
                            parkingDayMarti = true
                        }
                        var parkingDayMiercuri = false
                        let isMiercuri = object["MiercuriFrom"] as? Double ?? 30
                        if isMiercuri != 30 {
                            parkingDayMiercuri = true
                        }
                        var parkingDayJoi = false
                        let isJoi = object["JoiFrom"] as? Double ?? 30
                        if isJoi != 30 {
                            parkingDayJoi = true
                        }
                        var parkingDayVineri = false
                        let isVineri = object["VineriFrom"] as? Double ?? 30
                        if isVineri != 30 {
                            parkingDayVineri = true
                        }
                        var parkingDaySambata = false
                        let isSambata = object["SambataFrom"] as? Double ?? 30
                        if isSambata != 30 {
                            parkingDaySambata = true
                        }
                        var parkingDayDuminica = false
                        let isDuminica = object["DuminicaFrom"] as? Double ?? 30
                        if isDuminica != 30 {
                            parkingDayDuminica = true
                        }
                        
                        self.userParkingPlaces.append(SellerParkingPlace(parkID: parkID, isActive: isActive, isFree: isFree, isElectric: isElectric, adress: adress, price_hour: price_hour, price_day: price_day, currency: currency, parkingDayLuni: parkingDayLuni, parkingDayMarti: parkingDayMarti, parkingDayMiercuri: parkingDayMiercuri, parkingDayJoi: parkingDayJoi, parkingDayVineri: parkingDayVineri, parkingDaySambata: parkingDaySambata, parkingDayDuminica: parkingDayDuminica))
                    }
                } else {
                    self.userHaveParkingPlaces = false
                }
            }
        }
    }// end func search user patking places
    
    var locationManager: CLLocationManager?
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("show alert that location is off")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            permissionDenied.toggle()
            print("Your location is restricted.")
        case .denied:
            permissionDenied.toggle()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // getting user Region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hideLoading == false {
            self.hideLoading = true
            guard let location = locations.last else { return}
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 450, longitudinalMeters: 450)
            // updating map with current user location
            self.mapView.setRegion(self.region, animated: true)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        }
    }
    
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }// end func update map type
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            parkingPhone = currentUser?["phone_number"] as? String ?? ""
            parkingPhone = String(parkingPhone.replacingOccurrences(of: "+4", with: ""))
        }
        
        self.parkingAddress = ""
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0
        let lon: Double = Double("\(pdblLongitude)") ?? 0
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        self.finalLatitude = lat
        self.finalLongitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                if pm.subLocality != nil {
                    self.parkingAddress = self.parkingAddress + pm.subLocality! + ", "
                }
                // strada
                if pm.thoroughfare != nil {
                    self.parkingAddress = self.parkingAddress + pm.thoroughfare! + " "
                }
                // nr strada
                if pm.subThoroughfare != nil {
                    self.parkingAddress = self.parkingAddress + pm.subThoroughfare! + ", "
                }
                if pm.locality != nil {
                    self.parkingAddress = self.parkingAddress + pm.locality! + ", "
                    self.parkingCity = pm.locality!
                }
                if pm.country != nil {
                    self.parkingAddress = self.parkingAddress + pm.country! + ", "
                    self.parkingCountry = pm.country!
                }
                if pm.postalCode != nil {
                    self.parkingAddress = self.parkingAddress + pm.postalCode! + " "
                }
            }
        })
    }// end func get adress
    
    func addNewParkingSpot() {
        let currentUser = PFUser.current()
        
        if currentUser != nil {
            let newParking = PFObject(className: "ParkingSpots")
            newParking["seller"] = currentUser
            
            newParking["latitude"] = finalLatitude
            newParking["longitude"] = finalLongitude
            let point = PFGeoPoint(latitude: finalLatitude, longitude: finalLongitude)
            newParking["geo_point"] = point

            newParking["city"] = parkingCity
            newParking["country"] = parkingCountry
            newParking["address"] = parkingAddress
            
            newParking["is_electric"] = parkingIsElectric
            newParking["details_text"] = parkingDetails
            
            addParkingPrice(newParking: newParking)
        }
    }
    
    private func addParkingPrice(newParking: PFObject) {
        var hourPrice = "0"
        var dayPrice = "0"
        if parkingHourPrice != "" {
            hourPrice = priceConversion(price: parkingHourPrice)
        }
        if parkingDayPrice != "" {
            dayPrice = priceConversion(price: parkingDayPrice)
        }
         
        var doubleHourPrice: Double = 0
        var doubleDayPrice: Double = 0
        if hourPrice != "0" {
            doubleHourPrice = Double(hourPrice) ?? 0
        }
        if dayPrice != "0" {
            doubleDayPrice = Double(dayPrice) ?? 0
        }
        newParking["price_hour"] = doubleHourPrice
        if doubleDayPrice > 0 {
            newParking["price_day"] = doubleDayPrice
        }
        //moneda default LEI
        newParking["currency"] = PFObject(withoutDataWithClassName: "Currency", objectId: "8kYICgGwpT")

        addParkingPhone(newParking: newParking)
    }
    
    private func addParkingPhone(newParking: PFObject) {
        if parkingPhone == "" {
            //nimic
        } else if parkingPhone.count != 10 {
            self.alertTittle = "ErrorTitle"
            self.alertMessage = "ErrorPhoneNumber"
            self.alert.toggle()
            self.isSaving = 1
            return
        } else {
            if parkingPhone.isNumeric {
                let countryPrefix = "+4"
                newParking["phone"] = countryPrefix + parkingPhone
            } else {
                self.alertTittle = "ErrorTitle"
                self.alertMessage = "ErrorPhoneNumber"
                self.alert.toggle()
                self.isSaving = 1
                return
            }
        }
        
        addParkingPhoto(newParking: newParking)
    }
    
    private func addParkingPhoto(newParking: PFObject) {
        if parkingPicture.isEmpty {
            //nimic
        } else {
            // Modify Image Size
            let targetSize = CGSize(width: 1024 , height: 1024)
            let size = parkingPicture[0].size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            parkingPicture[0].draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // end Modify Image Size
            if newImage != nil {
                let imageData = newImage!.pngData()!
                let imageFile = PFFileObject(name: "parking.png", data: imageData)
                newParking["picture"] = imageFile
            }
        }
        
        addParkingDays(newParking: newParking)
    }
    
    private func addParkingDays(newParking: PFObject) {
        // luni
        if self.parkingDayLuni == true {
            let doubleLuniFrom = convertDate(fromDate: self.luniFrom, toDate: self.luniTo).from
            let doubleLuniTo = convertDate(fromDate: self.luniFrom, toDate: self.luniTo).to
            newParking["LuniFrom"] = doubleLuniFrom
            newParking["LuniTo"] = doubleLuniTo
//            if doubleLuniFrom == 0.0 && doubleLuniTo == 23.59 {
//                print("luni 24H")
//            }
        }
        // marti
        if self.parkingDayMarti == true {
            let doubleMartiFrom = convertDate(fromDate: self.martiFrom, toDate: self.martiTo).from
            let doubleMartiTo = convertDate(fromDate: self.martiFrom, toDate: self.martiTo).to
            newParking["MartiFrom"] = doubleMartiFrom
            newParking["MartiTo"] = doubleMartiTo
        }
        
        // miercuri
        if self.parkingDayMiercuri == true {
            let doubleMiercuriFrom = convertDate(fromDate: self.miercuriFrom, toDate: self.miercuriTo).from
            let doubleMiercuriTo = convertDate(fromDate: self.miercuriFrom, toDate: self.miercuriTo).to
            newParking["MiercuriFrom"] = doubleMiercuriFrom
            newParking["MiercuriTo"] = doubleMiercuriTo
        }
        
        // joi
        if self.parkingDayJoi == true {
            let doubleJoiFrom = convertDate(fromDate: self.joiFrom, toDate: self.joiTo).from
            let doubleJoiTo = convertDate(fromDate: self.joiFrom, toDate: self.joiTo).to
            newParking["JoiFrom"] = doubleJoiFrom
            newParking["JoiTo"] = doubleJoiTo
        }
        
        // vineri
        if self.parkingDayVineri == true {
            let doubleVineriFrom = convertDate(fromDate: self.vineriFrom, toDate: self.vineriTo).from
            let doubleVineriTo = convertDate(fromDate: self.vineriFrom, toDate: self.vineriTo).to
            newParking["VineriFrom"] = doubleVineriFrom
            newParking["VineriTo"] = doubleVineriTo
        }
        
        // sambata
        if self.parkingDaySambata == true {
            let doubleSambataFrom = convertDate(fromDate: self.sambataFrom, toDate: self.sambataTo).from
            let doubleSambataTo = convertDate(fromDate: self.sambataFrom, toDate: self.sambataTo).to
            newParking["SambataFrom"] = doubleSambataFrom
            newParking["SambataTo"] = doubleSambataTo
        }
        
        // sambata
        if self.parkingDayDuminica == true {
            let doubleDuminicaFrom = convertDate(fromDate: self.duminicaFrom, toDate: self.duminicaTo).from
            let doubleDuminicaTo = convertDate(fromDate: self.duminicaFrom, toDate: self.duminicaTo).to
            newParking["DuminicaFrom"] = doubleDuminicaFrom
            newParking["DuminicaTo"] = doubleDuminicaTo
        }
        
        newParking.saveInBackground() { (succes, error) in
            if let error = error {
                print("eroare salvare loc de parcare")
                print(error.localizedDescription)
                self.alertTittle = "ErrorTitle"
                self.alertMessage = "ErrorAddingParking"
                self.isSaving = 1
                self.alert.toggle()
            } else if (succes) {
               print("loc de parcare salvat cu succes")
                self.isSaving = 3
            }
            
        }
    }
    
    // end functions for Add parking spot to DB
    
    
    private func convertDate(fromDate: Date, toDate: Date) -> (from: Double, to: Double) {
        // convert date to string
        let dateStr = DateFormatter()
        dateStr.timeStyle = .short
        dateStr.dateStyle = .none
        let strFrom = dateStr.string(from: fromDate)
        let strTo = dateStr.string(from: toDate)
        // convert in HH:mm
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .none
        let shortFrom = format.date(from: strFrom)
        let shortTo = format.date(from: strTo)
        // time zone
        format.timeZone = TimeZone.current
        format.timeStyle = .short
        format.dateStyle = .none
        let finalDateFrom = format.string(from: shortFrom!)
        let finalDateTo = format.string(from: shortTo!)
        
        // MARK: - print for testing in replacingOccurrences
        /* Phone Setting > Language & Region - Region Format Example
         print("finalDateFrom - \(finalDateFrom)")
         print("finalDateTo - \(finalDateTo)") */
        
        var doubleFrom: Double = 0
        var doubleTo: Double = 0
        doubleFrom = Double(finalDateFrom.replacingOccurrences(of: ":", with: ".")) ?? 25
        doubleTo = Double(finalDateTo.replacingOccurrences(of: ":", with: ".")) ?? 25
        if doubleFrom == 25 {
            let dateFrom = timeConversion24(time12: finalDateFrom)
            doubleFrom = Double(dateFrom.replacingOccurrences(of: ":", with: ".")) ?? 0
        }
        if doubleTo == 25 {
            let dateTo = timeConversion24(time12: finalDateTo)
            doubleTo = Double(dateTo.replacingOccurrences(of: ":", with: ".")) ?? 0
        }
//        print("doubleFrom - \(doubleFrom)")
//        print("doubleTo - \(doubleTo)")
        return(doubleFrom,doubleTo)
    }
    
    private func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"
        let time24 = df.string(from: date!)
//        print(time24)
        return time24
    }
    
    private func priceConversion(price: String) -> String {
        let priceDouble = Double(price.replacingOccurrences(of: ",", with: ".")) ?? 0
        // If the Textfield is empty, 0 will be returned
        return String(format: "%.2f", priceDouble)
    }
}
