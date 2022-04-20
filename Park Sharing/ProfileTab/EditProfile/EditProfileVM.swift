//
//  EditProfileVM.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 04.11.2021.
//

import SwiftUI
import Parse

class EditProfileVM: ObservableObject {
    
    let currentUser = PFUser.current()
    
    @Published var userName = ""
    @Published var userEmail = ""
    @Published var userPic = ""
    @Published var userPhone = ""
    
    @Published var userCountry = ""
    @Published var userCounty = ""
    @Published var userCity = ""
    
    @Published var new_pozaProfil = [UIImage]()
    @Published var new_userPhone = ""
    
    // Error Alerts
    @Published var alert = false
    @Published var alertTittle = ""
    @Published var alertMessage = ""
    @Published var isSaving = 1
    
    @Published var countryArray = [CountryArray]()
    @Published var countryName = ""
    @Published var new_countryName = ""
    @Published var countryObj = PFObject(withoutDataWithClassName: "", objectId: "")
    
    @Published var countyArray = [CountryArray]()
    @Published var countyName = ""
    @Published var new_countyName = ""
    @Published var countyObj = PFObject(withoutDataWithClassName: "", objectId: "")
    
    @Published var cityArray = [CountryArray]()
    @Published var cityName = ""
    @Published var new_cityName = ""
    @Published var cityObj = PFObject(withoutDataWithClassName: "", objectId: "")
    
    func readUserInfo() {
        if currentUser != nil {
            userName = currentUser?.username ?? ""
            userEmail = currentUser?.email ?? ""
            
            let poza_main = currentUser?["profile_img"] as? PFFileObject
            userPic = poza_main?.url ?? ""
            userPhone = currentUser?["phone_number"] as? String ?? ""
            new_userPhone = userPhone
            
            let city_main = currentUser?["city"] as? PFObject
            if city_main != nil {
                if city_main?.objectId != nil {
                    self.cityObj = city_main!
                    let query = PFQuery(className: "Location_City")
                    query.includeKey("county")
                    query.includeKey("country")
                    query.getObjectInBackground(withId: cityObj.objectId!) { (object, error) in
                        if let error = error {
                            print("eroare citire oras, judet si tara")
                            print(error.localizedDescription)
                        } else if let object = object {
                            self.cityName = object["name"] as? String ?? ""
                            self.new_cityName = self.cityName
                            self.countyObj = object["county"] as! PFObject
                            self.countyName = self.countyObj["name"] as? String ?? ""
                            self.new_countyName = self.countyName
                            self.countryObj = object["country"] as! PFObject
                            self.countryName = self.countryObj["name"] as? String ?? ""
                            self.new_countryName = self.countryName
                        }
                    }
                } else {
                    print("city id gol")
                }
            } else {
                print("city main gol")
            }
        }
    }// end func READ
    
    func saveUserInfo() {
        if currentUser != nil {
            if new_pozaProfil.isEmpty {
                print("poza profil nemodificata")
            } else {
                // Modify Image Size
                let targetSize = CGSize(width: 400 , height: 400)
                let size = new_pozaProfil[0].size
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
                new_pozaProfil[0].draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                // end Modify Image Size
                if newImage != nil {
                    let imageData = newImage!.pngData()!
                    let imageFile = PFFileObject(name: "poza_profil.png", data: imageData)
                    self.currentUser!["profile_img"] = imageFile
                }
            }// end IF-ELSE poza profil
            
            if self.new_userPhone != self.userPhone {
                if new_userPhone.count != 10 {
                    self.alertTittle = "ErrorTitle"
                    self.alertMessage = "ErrorPhoneNumber"
                    self.alert.toggle()
                    self.isSaving = 1
                    return
                } else if new_userPhone.isNumeric {
                    print("new_userPhone")
                    let countryPrefix = "+4"
                    self.currentUser!["phone_number"] = countryPrefix + self.new_userPhone
                } else {
                    self.alertTittle = "ErrorTitle"
                    self.alertMessage = "ErrorPhoneNumber"
                    self.alert.toggle()
                    self.isSaving = 1
                    return
                }
            }
            
            if countryName != new_countryName {
                self.currentUser!["country"] = self.countryObj
            }
            if countyName != new_countyName {
                self.currentUser!["county"] = self.countyObj
            }
            if cityName != new_cityName {
                self.currentUser!["city"] = self.cityObj
            }
                        
            currentUser?.saveInBackground{ (succeeded, error)  in
                if (succeeded) {
                    self.isSaving = 3
                } else {
                    self.isSaving = 4
                    print("eroare salvare date user")
                    print(error?.localizedDescription as Any)
                }
                
            }
        }
    } // end func SAVE
    
    func readCountryList() {
        countryArray.removeAll()
        let query = PFQuery(className: "Location_Country")
        query.order(byAscending: "name")
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print("eroare citire tari")
                print(error.localizedDescription)
            } else if let objects = objects {
                for object in objects  {
                    let name = object["name"] as? String ?? ""
                    self.countryArray.append(CountryArray(name: name, object: object))
                }
            }
        }
    }
    
    func readCountyList(country: PFObject) {
        countyArray.removeAll()
        let query = PFQuery(className: "Location_County")
        query.whereKey("country", equalTo: country)
        query.order(byAscending: "name")
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print("eroare citire judete")
                print(error.localizedDescription)
            } else if let objects = objects {
                for object in objects {
                    let name = object["name"] as? String ?? ""
                    self.countyArray.append(CountryArray(name: name, object: object))
                }
            }
        }
    }
    
    func readCityList(county: PFObject) {
        cityArray.removeAll()
        let query = PFQuery(className: "Location_City")
        query.whereKey("county", equalTo: county)
        query.order(byAscending: "name")
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print("eroare citire orase")
                print(error.localizedDescription)
            } else if let objects = objects {
                for object in objects {
                    let name = object["name"] as? String ?? ""
                    self.cityArray.append(CountryArray(name: name, object: object))
                }
            }
        }
    }
}
