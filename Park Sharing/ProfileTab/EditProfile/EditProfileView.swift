//
//  EditProfileView.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 31.10.2021.
//

import SwiftUI
import PhotosUI
import Parse

struct EditProfileView: View {
    @State var reloadView = true
    
    @StateObject var editVM = EditProfileVM()
    
    @State var sellectPhoto: Bool = false
    @State var pickerResult: [UIImage] = []
    var config: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images //videos, livePhotos...
        config.selectionLimit = 1
        return config
    }
    var body: some View {
        VStack {
            Button(action: {
                sellectPhoto.toggle()
            }){
                ZStack(alignment: .bottomTrailing) {
                    if pickerResult.isEmpty {
                        AsyncImageView(img_url: editVM.userPic)
                            .modifier(RoundPhoto())
                    } else {
                        ForEach( pickerResult, id: \.self) { image in
                            Image.init(uiImage: image)
                                .resizable()
                                .modifier(RoundPhoto())
                        }
                    }
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.black)
                        .background(.white)
                        .clipShape(Circle())
                }
                .padding()
                .sheet(isPresented: $sellectPhoto) {
                    UserPhotoPicker(configuration: self.config, pickerResult: $pickerResult, isPresented: $sellectPhoto, photosForUpload: $editVM.new_pozaProfil)
                }
            }
            
            VStack(spacing: 10) {
                ImageProfileRow(icon: "person", placeholder: "Username", text: $editVM.userName)
                    .disabled(true)
                ImageProfileRow(icon: "phone", placeholder: "PhoneNumber", text: $editVM.new_userPhone)
                    .keyboardType(.numberPad)
                ImageProfileRow(icon: "envelope", placeholder: "EmailAdress", text: $editVM.userEmail)
                    .disabled(true)
                
                NavigationLink(destination: SelectCountry(vm: editVM)) {
                    ImageProfileRowArrow(icon: "map", placeholder: "Country", text: $editVM.new_countryName)
                }
                if editVM.new_countryName != "" {
                    NavigationLink(destination: SelectCounty(vm: editVM, country: editVM.countryObj)) {
                        ImageProfileRowArrow(icon: "building.2", placeholder: "County", text: $editVM.new_countyName)
                    }
                }
                if editVM.new_countyName != "" {
                    NavigationLink(destination: SelectCity(vm: editVM, county: editVM.countyObj)) {
                        ImageProfileRowArrow(icon: "building", placeholder: "City", text: $editVM.new_cityName)
                    }
                }
            }
            .padding(.vertical)
            .modifier(BgWhiteShadowCornerRadius())
            
            Spacer()
        }
        .alert(isPresented: $editVM.alert, content: {
            Alert(title: Text(LocalizedStringKey(editVM.alertTittle)), message: Text(LocalizedStringKey(editVM.alertMessage)), dismissButton: .destructive(Text("Ok"), action: {
            }))
        })
        .navigationBarTitleDisplayMode(.inline)
        //        .navigationTitle(LocalizedStringKey("EditProfile"))
        .background(Color("MainColor").edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation() {
                        editVM.isSaving = 2
                    }
                    editVM.saveUserInfo()
                }) {
                    SaveTextView(number: $editVM.isSaving)
                }
                .disabled(editVM.isSaving == 2)
                .disabled(editVM.isSaving == 3)
            }
        }
        .onAppear(perform: {
            if reloadView {
                editVM.readUserInfo()
                reloadView = false
            }
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}

struct EditProfilRow: View {
    var placeholder: LocalizedStringKey
    var text: String
    var body: some View {
        HStack {
            Text(placeholder)
                .foregroundColor(.gray)
                .frame(width: 90, alignment: .leading)
            Text(text)
                .foregroundColor(.black)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ImageProfileRow: View {
    var icon: String
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 25, height: 25, alignment: .center)
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder).foregroundColor(.gray)
                }
                .foregroundColor(.black)
                .font(.headline)
                .lineLimit(1)
                .padding(.vertical, 5)
        }
        .padding(.horizontal)
    }
}

struct ImageProfileRowArrow: View {
    var icon: String
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 25, height: 25, alignment: .center)
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder).foregroundColor(.gray)
                }
                .multilineTextAlignment(.leading)
                .disabled(true)
                .foregroundColor(.black)
                .font(.headline)
                .lineLimit(1)
                .padding(.vertical, 5)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
    }
}

struct SelectCountry: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: EditProfileVM
    let emptyObj = PFObject(withoutDataWithClassName: "", objectId: "")
    var body: some View {
        VStack {
            if vm.countryArray.isEmpty {
                LoadingViewMainColor()
            } else {
                List {
                    ForEach(vm.countryArray) { item in
                        SelectLocationRow(name: item.name)
                            .onTapGesture {
                                vm.new_countyName = ""
                                vm.countyObj = emptyObj
                                vm.new_cityName = ""
                                vm.cityObj = emptyObj
                                vm.new_countryName = item.name
                                vm.countryObj = item.object
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
        }
        .animation(.easeIn, value: vm.countryArray.count)
        .navigationTitle(LocalizedStringKey("SelectCountry"))
        .onAppear(perform: {
            vm.readCountryList()
        })
    }
}

struct SelectCounty: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: EditProfileVM
    let emptyObj = PFObject(withoutDataWithClassName: "", objectId: "")
    var country: PFObject
    var body: some View {
        VStack {
            if vm.countyArray.isEmpty {
                LoadingViewMainColor()
            } else {
                List {
                    ForEach(vm.countyArray) { item in
                        SelectLocationRow(name: item.name)
                            .onTapGesture {
                                vm.new_cityName = ""
                                vm.cityObj = emptyObj
                                vm.new_countyName = item.name
                                vm.countyObj = item.object
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
        }
        .animation(.easeIn, value: vm.countyArray.count)
        .navigationTitle(LocalizedStringKey("SelectCounty"))
        .onAppear(perform: {
            vm.readCountyList(country: country)
        })
    }
}

struct SelectCity: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: EditProfileVM
    var county: PFObject
    var body: some View {
        VStack {
            if vm.cityArray.isEmpty {
                LoadingViewMainColor()
            } else {
                List {
                    ForEach(vm.cityArray) { item in
                        SelectLocationRow(name: item.name)
                            .onTapGesture {
                                vm.new_cityName = item.name
                                vm.cityObj = item.object
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
        }
        .animation(.easeIn, value: vm.cityArray.count)
        .navigationTitle(LocalizedStringKey("SelectCity"))
        .onAppear(perform: {
            vm.readCityList(county: county)
        })
    }
}

struct SelectLocationRow: View {
    var name: String
    var body: some View {
            HStack {
                Text(name)
                    .foregroundColor(.primary)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.vertical, 5)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
    }
}

//struct SelectLocationRow: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var name: String
//    var object: PFObject
//    @Binding var returnName: String
//    @Binding var returnObject: PFObject
//    var body: some View {
//        Button(action: {
//            self.returnName = self.name
//            self.returnObject = self.object
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Text(name)
//                    .foregroundColor(.primary)
//                    .font(.headline)
//                    .lineLimit(1)
//                    .padding(.vertical, 5)
//
//                Spacer()
//
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}

