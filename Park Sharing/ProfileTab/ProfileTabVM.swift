//
//  ProfileTabVM.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import Foundation
import Parse

final class ProfileTabViewModel: ObservableObject {
    let currentUser = PFUser.current()
    
    @Published var userName = ""
    @Published var userPic = ""
    @Published var licensePlate = ""
    
    func readUserInfo() {
        if currentUser != nil {
            userName = currentUser?.username ?? ""
            let poza_main = currentUser?["profile_img"] as? PFFileObject
            userPic = poza_main?.url ?? ""
        }
    }
    
    func logOutUser() {
        PFUser.logOut()
    }
    
    
}
