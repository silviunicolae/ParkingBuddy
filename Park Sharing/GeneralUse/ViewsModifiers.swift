//
//  ViewsModifiers.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 11.10.2021.
//

import SwiftUI

struct CustomCorner : Shape {
    var corners : UIRectCorner
    var size : CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        return Path(path.cgPath)
    }
}


struct BgWhiteShadowCornerRadius: ViewModifier {
    
    func body(content: Content) -> some View {
        
        return content
            .background(.white)
            .cornerRadius(8)
            .shadow(color: Color.gray.opacity(0.3), radius: 3, x:2, y: 2)
            .padding(.horizontal)
    }
}

struct RoundPhoto: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .scaledToFill()
            .frame(width: 100, height: 100)
            .background(.white)
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 2))
    }
}

// MARK: - Toggle Style / Check Box
struct AddElectricToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(.spring()) {
                configuration.isOn.toggle()
            }
        } label: {
            HStack {
                configuration.label
                    .foregroundColor(configuration.isOn ? Color.black : Color.gray)
                Spacer()
                    Image(systemName: configuration.isOn ? "battery.100.bolt" : "battery.0")
                    .foregroundColor(configuration.isOn ? .green : .gray)
                        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                        .padding(.trailing, 3)
                }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeOut, value: configuration.isOn)
            .foregroundColor(.black)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width - 60, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isOn ? .gray.opacity(0.5) : .gray.opacity(0.9), lineWidth: 0.5)
                    .background(.white)
                    .cornerRadius(8)
            )
    }
}
