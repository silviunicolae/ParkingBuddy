//
//  AsyncImageView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 04.11.2021.
//

import SwiftUI

struct AsyncImageView: View {
    var img_url: String
    var body: some View {
        AsyncImage(
                    url: URL(string: img_url),
                    transaction: Transaction(animation: .easeIn)
                ) { phase in
                    switch phase {
                    case .empty:
                        LoadingViewMainColor()
                    case .success(let image):
                        image
                            .resizable()
                            .transition(.opacity)
                    case .failure:
                        Image(systemName: "wifi.slash")
                    @unknown default:
                        EmptyView()
                    }
                }
    }
}
