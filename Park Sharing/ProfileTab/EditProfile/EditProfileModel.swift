//
//  EditProfileModel.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 04.11.2021.
//

import Foundation
import Parse

struct CountryArray: Identifiable {
    var id = UUID()
    var name: String
    var object: PFObject
}
