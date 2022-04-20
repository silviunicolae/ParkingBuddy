//
//  HomeMapViewModel.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import CoreLocation
import MapKit
import Parse

enum MapDetails {
    //    static let startingLocation = CLLocationCoordinate2D(latitude: 45.75372, longitude: 21.22571)
    static let startingLocation = CLLocationCoordinate2D(latitude: 49.75372, longitude: 29.22571)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
}

final class HomeMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var permissionDenied = false
    @Published var availableParkingSpots = [ParkingSpots]()
    
    private var finalLatitude: Double = 0
    private var finalLongitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            self.finalLatitude = locationManager?.location?.coordinate.latitude ?? 0
            self.finalLongitude = locationManager?.location?.coordinate.longitude ?? 0
            print("final if : \(finalLatitude) , \(finalLongitude)")
            loadParkingSpots()
        } else {
            print("show alert that location is off")
            //            loadParkingSpots()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }
    
    private func checkLocationAutorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            permissionDenied.toggle()
            print("Your location is restricted.")
        case .denied:
            permissionDenied.toggle()
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
            self.finalLatitude = region.center.latitude
            self.finalLongitude = region.center.longitude
            print("final: \(finalLatitude) , \(finalLongitude)")
            //            loadParkingSpots()
            //            print(locationManager.location?.coordinate)
            //            locationManager.stopUpdatingLocation()
        @unknown default:
            break
        }
    }
    //    let point = PFGeoPoint(latitude:40.0, longitude:-30.0)
    
    private func loadParkingSpots() {
        print("loading...")
        availableParkingSpots.removeAll()
        
        let timeNow = checkTimeNow()
        let dayFrom = getDayOfWeek().from
        let dayTo = getDayOfWeek().to
        print("\(dayFrom) - \(dayTo)")
        print("timeNow - \(timeNow)")
        
        let point = PFGeoPoint(latitude: finalLatitude, longitude: finalLongitude)
        
        let query = PFQuery(className: "ParkingSpots")
        query.whereKey("is_Active", equalTo: true)
        query.whereKey(dayFrom, lessThanOrEqualTo: timeNow)
        query.whereKey(dayTo, greaterThanOrEqualTo: timeNow)
        query.whereKey("geo_point", nearGeoPoint: point, withinKilometers: 5)
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print("eroare gasire locuri de parcare")
                print(error.localizedDescription)
                return
            } else {
                if let returnedObjects = objects {
                    for object in returnedObjects {
                        let parkID = object.objectId ?? ""
                        let latitude = object["latitude"] as? Double ?? 0
                        let longitude = object["longitude"] as? Double ?? 0
                        let electric = object["is_electric"] as? Bool ?? false
                        let startTime = object[dayFrom] as? Double ?? 29
                        let endTime = object[dayTo] as? Double ?? 29
                        
                        var is24H = false
                        if startTime == 0 && endTime == 23.59 {
                            is24H = true
                        }
                        self.availableParkingSpots.append(ParkingSpots(parkID: parkID, latitude: latitude, longitude: longitude, electric: electric, is24h: is24H))
                    }
                } else {
                    print("empty")
                }
            }
        }
    }// end func load parking spots
    
    private func checkTimeNow() -> Double {
        //check today
        let currentDay = Date()
        let currentFormat = DateFormatter()
        currentFormat.timeStyle = .short
        currentFormat.dateStyle = .none
        let currentDayToCheck = currentFormat.string(from: currentDay)
        var doubleDate: Double = 0
        doubleDate = Double(currentDayToCheck.replacingOccurrences(of: ":", with: ".")) ?? 25
        if doubleDate == 25 {
            let dateUS = timeConversion24(time12: currentDayToCheck)
            doubleDate = Double(dateUS.replacingOccurrences(of: ":", with: ".")) ?? 0
        }
        return doubleDate
    }
    
    private func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm"
        let time24 = df.string(from: date!)
        return time24
    }
    
    private func getDayOfWeek() -> (from: String, to: String) {
        let today = Date().dayNumberOfWeek()!
        switch today {
        case 1:
            return ("DuminicaFrom","DuminicaTo")
        case 2:
            return ("LuniFrom","LuniTo")
        case 3:
            return ("MartiFrom","MartiTo")
        case 4:
            return ("MiercuriFrom","MiercuriTo")
        case 5:
            return ("JoiFrom","JoiTo")
        case 6:
            return ("VineriFrom","VineriTo")
        case 7:
            return ("SambataFrom","SambataTo")
        default:
            print("eroare citire zi")
            return ("","")
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        // returns day in English
        return dateFormatter.string(from: self).capitalized
    }
}

