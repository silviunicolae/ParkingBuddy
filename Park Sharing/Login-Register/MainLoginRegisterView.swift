//
//  MainLoginRegisterView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 11.10.2021.
//

import SwiftUI

struct MainLoginRegisterView: View {
    @StateObject var loginVM = LoginRegisterData()
    @Binding var isUserLogedIn: String?
    
    var body: some View {
        if loginVM.showWindow == "intro" {
            IntroView(showWindow: $loginVM.showWindow)
                .edgesIgnoringSafeArea(.all)
        } else if loginVM.showWindow == "login" {
            LoginView(loginVM: loginVM, isUserLogedIn: $isUserLogedIn)
        } else if loginVM.showWindow == "register" {
            RegisterView(loginVM: loginVM, isUserLogedIn: $isUserLogedIn)
        }
    }
}

//struct MainLoginRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainLoginRegisterView()
//    }
//}

struct IntroView: View {
    @Binding var showWindow: String
    var body: some View {
        ZStack {
            VStack {
                IntroPicture()
                    .clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight], size: 40))
                Spacer()
            }
            
            VStack {
                Spacer()
                IntroButton(showWindow: $showWindow)
            }
        }
        .background(Color("MainColor"))
    }
}

struct IntroPicture: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Image("login-register-1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                Spacer()
            }
            Text("Caută locuri de parcare în orașul tău")
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .font(.title)
            Text("Ai treabă în oraș dar nu știi unde să parchezi mașina? Descoperă un loc de parcare liber și parchează mașina în siguranță")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .font(.callout)
        }
        .padding(.horizontal, 20)
        .frame(height: (UIScreen.main.bounds.height / 3)*2)
        .background(Color.white)
    }
}

struct IntroButton: View {
    @Binding var showWindow: String
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.linear) {
                    showWindow = "register"
                }
            }) {
                Text("Înregistrare")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(width: (UIScreen.main.bounds.width / 2) - 50, height: 40)
            .modifier(BtnWhiteBorder())
            
            Button(action: {
                withAnimation(.linear) {
                    showWindow = "login"
                }
                
            }) {
                Text("Logare")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(width: (UIScreen.main.bounds.width / 2) - 50, height: 40)
            .modifier(BtnWhiteBackground())
            
        }
        .frame(height: UIScreen.main.bounds.height / 3)
    }
}
