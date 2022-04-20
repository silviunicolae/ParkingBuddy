//
//  AppButtons.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 11.10.2021.
//

import SwiftUI

struct BtnMainColorBackground: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color("MainColor"))
            .cornerRadius(8)
    }
}

struct BtnWhiteBackground: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color("MainColor"))
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(8)
    }
}

struct BtnWhiteBorder: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 1)
            )
    }
}

struct BtnAddItem: View {
    let image: String
    var body: some View {
        VStack {
            Image(systemName: image)
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color("MainColor"))
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
            
            
        }
    }
}
