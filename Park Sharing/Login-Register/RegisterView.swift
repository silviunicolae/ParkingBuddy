//
//  RegisterView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 12.10.2021.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var loginVM: LoginRegisterData
    @Binding var isUserLogedIn: String?
    var body: some View {
        VStack {
            RegisterLogo()
                .padding(.vertical, 50)
            RegisterBottom(loginVM: loginVM, isUserLogedIn: $isUserLogedIn)
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

//struct RegisterView_Previews: PreviewProvider {
//    @State static var showWindow: String = "login"
//    @State static var username: String = ""
//    @State static var password: String = ""
//    @State static var passwordCheck: String = ""
//    @State static var email: String = ""
//    static var previews: some View {
//        RegisterView(showWindow: $showWindow, username: $username, password: $password, passwordCheck: $passwordCheck, email: $email)
//    }
//}

struct RegisterLogo: View {
    var body: some View {
        VStack {
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

struct RegisterBottom: View {
    @ObservedObject var loginVM: LoginRegisterData
    @Binding var isUserLogedIn: String?
    var body: some View {
        VStack(spacing: 20) {
            NormalTextField(placeholder: "User", text: $loginVM.username)
            PasswordTextField(placeholder: "Parolă", text: $loginVM.password)
            PasswordTextField(placeholder: "Parolă", text: $loginVM.passwordCheck)
            NormalTextField(placeholder: "Email", text: $loginVM.email)
                .keyboardType(.emailAddress)
            Spacer()
            
            Button(action: {
                loginVM.tryRegister = 2
                loginVM.registerUser()
                
                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if loginVM.loginSucces {
                        timer.invalidate()
                        withAnimation(.linear) {
                            UserDefaults.standard.set(loginVM.username, forKey: "UserLogedIn")
                            isUserLogedIn = loginVM.username
                        }
                    }
                    if loginVM.tryRegister == 1 {
                        timer.invalidate()
                    }
                }
            }) {
                if loginVM.tryRegister == 2 {
                    LoadingViewWhite()
                } else {
                    HStack {
                        Spacer()
                        Text("Crează cont")
                        Spacer()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 80, height: 40)
            .modifier(BtnMainColorBackground())
            .disabled(loginVM.tryRegister == 2)
            
            Spacer()
            
            HStack {
                Text("Ești deja membru?")
                    .fontWeight(.light)
                    .foregroundColor(.black)
                Button(action: {
                    withAnimation(.linear) {
                        loginVM.showWindow = "login"
                    }
                }){
                    Text("Logează-te")
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
