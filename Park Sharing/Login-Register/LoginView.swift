//
//  LoginView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 12.10.2021.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginVM: LoginRegisterData
    @Binding var isUserLogedIn: String?
    var body: some View {
        VStack {
            LoginLogo()
                .padding(.vertical, 50)
            LoginBottom(loginVM: loginVM, isUserLogedIn: $isUserLogedIn)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BgColor"))
                .clipShape(CustomCorner(corners: [.topLeft, .topRight], size: 40))
                .edgesIgnoringSafeArea(.all)
        }
        .alert(isPresented: $loginVM.alert, content: {
            Alert(title: Text(LocalizedStringKey(loginVM.alertTittle)), message: Text(LocalizedStringKey(loginVM.alertMessage)), dismissButton: .destructive(Text("Ok"), action: {
            }))
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    @State static var showWindow: String = "login"
//    @State static var username: String = ""
//    @State static var password: String = ""
//    static var previews: some View {
//        LoginView(showWindow: $showWindow, username: $username, password: $password)
//    }
//}

struct LoginLogo: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            HStack(spacing: 2) {
                Text("Parking")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Buddy")
                    .fontWeight(.bold)
                    .foregroundColor(Color("MainColor"))
            }
            .font(.largeTitle)
            
            Text("Găsește rapid un loc de parcare")
                .foregroundColor(.gray)
                .font(.callout)
        }
    }
}

struct LoginBottom: View {
    @ObservedObject var loginVM: LoginRegisterData
    @Binding var isUserLogedIn: String?
    var body: some View {
        VStack(spacing: 20) {
            NormalTextField(placeholder: "User", text: $loginVM.username)
            PasswordTextField(placeholder: "Parolă", text: $loginVM.password)
            
            Spacer()
            
            Button(action: {
                loginVM.tryLogin = 2
                loginVM.loginUser()
                
                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if loginVM.loginSucces {
                        timer.invalidate()
                        withAnimation(.linear) {
                            UserDefaults.standard.set(loginVM.username, forKey: "UserLogedIn")
                            isUserLogedIn = loginVM.username
                        }
                    }
                    if loginVM.tryLogin == 1 {
                        timer.invalidate()
                    }
                }
            }) {
                if loginVM.tryLogin == 2 {
                    LoadingViewWhite()
                } else {
                    HStack {
                        Spacer()
                        Text("Logare")
                        Spacer()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 80, height: 40)
            .modifier(BtnMainColorBackground())
            .disabled(loginVM.tryLogin == 2)
            
            Spacer()
            
            HStack {
                Text("Nu ești încă un membru?")
                    .fontWeight(.light)
                    .foregroundColor(.black)
                Button(action: {
                    withAnimation(.linear) {
                        loginVM.showWindow = "register"
                    }
                }){
                    Text("Creează cont")
                        .foregroundColor(Color("MainColor"))
                }
            }
            .font(.footnote)
        }
        .padding(.vertical, 30)
        .onTapGesture {
            hideKeyboard()
        }
    }
}
