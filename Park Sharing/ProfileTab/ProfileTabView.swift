//
//  ProfileTabView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 28.10.2021.
//

import SwiftUI

struct ProfileTabView: View {
    @StateObject var profileVM = ProfileTabViewModel()
    @Binding var isUserLogedIn: String?
    
    var body: some View {
        VStack {
            ProfileHeader(vm: profileVM)
            
            VStack(spacing: 18) {
                UserItemsGroup()
                
                SellerItemsGroup()
                
                GeneralItemsGroup()
            }
            
            Spacer()
            
            ProfileLogOut()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .background(Color("BgColor"))
        .onAppear(perform: {
            profileVM.readUserInfo()
        })
    }
    
    fileprivate func ProfileLogOut() -> some View {
        return VStack {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25, alignment: .center)
                
                Button(action: {
                    profileVM.logOutUser()
                    UserDefaults.standard.set("", forKey: "UserLogedIn")
                    isUserLogedIn = ""
                }) {
                    Text(LocalizedStringKey("BtnLogOut"))
                        .foregroundColor(.black)
                        .font(.headline)
                }
                
                Spacer()
            }
            .padding()
        }
        .modifier(BgWhiteShadowCornerRadius())
        .padding(.bottom, 30)
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    @State static var isUserLogedIn: String? = ""
    static var previews: some View {
        ProfileTabView(isUserLogedIn: $isUserLogedIn)
    }
}

struct ProfileHeader: View {
    @ObservedObject var vm: ProfileTabViewModel
    var body: some View {
        VStack {
            NavigationLink(destination: EditProfileView()) {
                HStack(alignment: .center, spacing: 10) {
                    AsyncImageView(img_url: vm.userPic)
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .background(.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                    
                    VStack(alignment: .leading) {
                        Text(vm.userName)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        if vm.licensePlate != "" {
                            Text(vm.licensePlate)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("BgColor"))
                }
                .padding()
            }
        }.background(Color("MainColor"))
    }
}

struct UserItemsGroup: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ForEach(userItems) { item in
                    NavigationLink(destination: item.destination) {
                        ProfileOptionRow(icon: item.icon, name: item.name)
                    }
                }
            }
            .padding()
        }
        .modifier(BgWhiteShadowCornerRadius())
    }
}

struct SellerItemsGroup: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ForEach(sellerItems) { item in
                    NavigationLink(destination: item.destination) {
                        ProfileOptionRow(icon: item.icon, name: item.name)
                    }
                }
            }
            .padding()
        }
        .modifier(BgWhiteShadowCornerRadius())
    }
}

struct GeneralItemsGroup: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ForEach(generalItems) { item in
                    NavigationLink(destination: item.destination) {
                        ProfileOptionRow(icon: item.icon, name: item.name)
                    }
                }
            }
            .padding()
        }
        .modifier(BgWhiteShadowCornerRadius())
    }
}


struct ProfileOptionRow: View {
    var icon: String
    var name: LocalizedStringKey
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 25, height: 25, alignment: .center)
            
            Text(name)
                .foregroundColor(.black)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}
