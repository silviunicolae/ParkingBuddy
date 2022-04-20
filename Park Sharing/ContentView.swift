//
//  ContentView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 11.10.2021.
//

import SwiftUI

struct ContentView: View {
    @State var isUserLogedIn = UserDefaults.standard.string(forKey: "UserLogedIn")
    var body: some View {
        if isUserLogedIn == nil {
            MainLoginRegisterView(isUserLogedIn: $isUserLogedIn)
        } else if isUserLogedIn == "" {
            MainLoginRegisterView(isUserLogedIn: $isUserLogedIn)
        } else {
            CustomTabBar(isUserLogedIn: $isUserLogedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
