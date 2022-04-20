//
//  AppFields.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 12.10.2021.
//

import SwiftUI

struct NormalTextField: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .textFiledPlaceholder(text: self.text)
            TextField("", text: $text)
        }
        .textFieldShape(text: self.text)
    }
}

struct PasswordTextField: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    @State var showText = false
    var body: some View {
        if showText {
            HStack {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                Button(action: {
                    withAnimation() {
                        showText.toggle()
                    }
                }){
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                }
            }
            .textFieldShape(text: self.text)
        } else {
            HStack {
                SecureField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                Button(action: {
                    withAnimation() {
                        showText.toggle()
                    }
                }){
                    Image(systemName: "eye")
                        .foregroundColor(.gray)
                    //                        .foregroundColor(Color(UIColor.placeholderText))
                }
            }
            .textFieldShape(text: self.text)
        }
    }
}

struct PriceTextField: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var currency: LocalizedStringKey
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .textFiledPlaceholder(text: self.text)
            HStack {
                TextField("", text: $text)
                Text(currency)
                    .foregroundColor(self.text.isEmpty ? .clear : .gray)
            }
        }
        .textFieldShape(text: self.text)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func textFieldShape(text: String) -> some View {
        self.animation(.easeOut, value: text.isEmpty)
            .foregroundColor(.black)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width - 60, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(text.isEmpty ? .gray.opacity(0.5) : .gray.opacity(0.9), lineWidth: 0.5)
                    .background(.white)
                    .cornerRadius(8)
            )
        
    }
    
    func textFiledPlaceholder(text: String) -> some View {
        self.font(text.isEmpty ? .body : .subheadline)
            .foregroundColor(.gray)
            .padding(.horizontal, text.isEmpty ? 0 : 10)
            .background(.white)
            .cornerRadius(5)
            .offset(y: text.isEmpty ? 0 : -23)
            .scaleEffect(text.isEmpty ? 1 : 0.9, anchor: .leading)
    }
}

struct CustomTextEditor: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .leading) {
            
            TextEditor(text: self.$text)
                .multilineTextAlignment(.leading)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
            
            Text(placeholder)
                .font(text.isEmpty ? .body : .subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, self.text.isEmpty ? 0 : 10)
                .background(.white)
                .cornerRadius(5)
                .offset(y: self.text.isEmpty ? 0 : -46)
                .scaleEffect(self.text.isEmpty ? 1 : 0.9, anchor: .leading)
        }
        .foregroundColor(.black)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width - 60, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(text.isEmpty ? .gray.opacity(0.5) : .gray.opacity(0.9), lineWidth: 0.5)
                .cornerRadius(8)
                .background(.white)
        )
    }
}

