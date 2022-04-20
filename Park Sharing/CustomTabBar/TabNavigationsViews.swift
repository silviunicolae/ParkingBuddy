//
//  TabNavigationsViews.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 31.10.2021.
//

import SwiftUI

struct ProfileTabNavigation: View {
    @Binding var isUserLogedIn: String?
    var body: some View {
        NavigationView {
            ProfileTabView(isUserLogedIn: $isUserLogedIn)
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(Color("BgColorInversat"))
        }
    }
}
