//
//  LoadingViews.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 27.10.2021.
//

import SwiftUI

struct LoadingViewMainColor : View {
    var body: some View{
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("MainColor")))
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingViewTwoMainColor : View {
    var body: some View{
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("MainColor")))
                .scaleEffect(2)
        }
    }
}

struct LoadingViewWhite : View {
    var body: some View{
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        }
    }
}

struct LoadingViewTwoWhite : View {
    var body: some View{
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .scaleEffect(2)
        }
    }
}
