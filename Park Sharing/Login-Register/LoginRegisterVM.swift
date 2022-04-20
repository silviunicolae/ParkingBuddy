//
//  LoginRegisterVM.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 27.10.2021.
//

import SwiftUI
import Parse

class LoginRegisterData : ObservableObject {
    
    @Published var showWindow: String = "intro"
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var email: String = ""
    @Published var loginSucces: Bool = false
    @Published var tryLogin: Int = 1
    @Published var tryRegister: Int = 1
    
    // Error Alerts
    @Published var alert = false
    @Published var alertTittle = ""
    @Published var alertMessage = ""
    
    func loginUser() {
        if username == "" || password == "" {
            self.alertTittle = "ErrorTitle"
            self.alertMessage = "ErrorEmptyField"
            self.alert.toggle()
            tryLogin = 1
            return
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) -> Void in
            if error != nil {
                print("pag LoginRgisterVM")
                print(error!.localizedDescription)
                print(error!._code)
                self.alertTittle = "ErrorTitle"
                self.alertMessage = "ErrorInvalidUserPas"
                self.alert.toggle()
                self.tryLogin = 1
                return
            } else if user != nil {
                //pentru schimbare user in instalation push
                if let installation = PFInstallation.current(){
                    if let userId = PFUser.current()?.objectId {
                        installation.setObject(userId, forKey: "userId")
                    }
                    installation.saveInBackground {
                        (success: Bool, error: Error?) in
                        if (success) {
                            print("modificat succes")
                        } else {
                            if let myError = error{
                                print("Error saving user nou push \(myError.localizedDescription)")
                            }else{
                                print("Uknown error")
                            }
                        }
                    }
                }
                //end pentru schimbare user in instalation push
                self.loginSucces = true
            }
        }
    }// end func LOGIN
    
    func registerUser() {
        if username == "" || password == "" || passwordCheck == "" || email == "" {
            self.alertTittle = "ErrorTitle"
            self.alertMessage = "ErrorEmptyField"
            self.alert.toggle()
            tryRegister = 1
            return
        }
        
        if password != passwordCheck {
            self.alertTittle = "ErrorTitle"
            self.alertMessage = "ErrorPassdNotMatch"
            self.alert.toggle()
            tryRegister = 1
            return
        }
        
        let user = PFUser()
        //verificam daca ultimul caracter este spatiu
        let verificaSpatiu = username.last
        if verificaSpatiu == " "{
            let spatiuEliminat = username.dropLast()
            user.username = String(spatiuEliminat)
            username  = String(spatiuEliminat)
        } else {
            user.username       = username
        }
        user.password       = password
        user.email          = email.lowercased()
        
        user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                switch error!._code {
                case 202:
                    self.alertTittle = "ErrorTitle"
                    self.alertMessage = "ErrorUserNameExists"
                    self.alert.toggle()
                    self.tryRegister = 1
                    return
                case 203:
                    self.alertTittle = "ErrorTitle"
                    self.alertMessage = "ErrorEmailExists"
                    self.alert.toggle()
                    self.tryRegister = 1
                    return
                default:
                    self.alertTittle = "ErrorTitle"
                    self.alertMessage = "ErrorUnknown"
                    self.alert.toggle()
                    self.tryRegister = 1
                    return
                }
            } else {
                PFUser.logInWithUsername(inBackground: self.username, password: self.password) { (user: PFUser?, error: Error?) -> Void in
                    if error != nil {
                        print("pag LoginRgisterVM")
                        print(error!.localizedDescription)
                        print(error!._code)
                        self.alertTittle = "ErrorTitle"
                        self.alertMessage = "ErrorRegisterLogin"
                        self.alert.toggle()
                        self.tryRegister = 1
                        return
                    } else if user != nil {
                        //pentru schimbare user in instalation push
                        if let installation = PFInstallation.current(){
                            if let userId = PFUser.current()?.objectId {
                                installation.setObject(userId, forKey: "userId")
                            }
                            installation.saveInBackground {
                                (success: Bool, error: Error?) in
                                if (success) {
                                    print("modificat succes")
                                } else {
                                    if let myError = error{
                                        print("Error saving user nou push \(myError.localizedDescription)")
                                    }else{
                                        print("Uknown error")
                                    }
                                }
                            }
                        }
                        //end pentru schimbare user in instalation push
                        self.loginSucces = true
                    }
                }
            }
        }
    }// end func REGISTER
    
    func logOutUser() {
        PFUser.logOut()
    }
}
