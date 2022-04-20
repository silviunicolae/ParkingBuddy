//
//  CustomTabBar.swift
//  Park Sharing
//
//  Created by Silviu Nicolae on 27.10.2021.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var isUserLogedIn: String?
    @State var currentTab: Tab = .home
    
    // Matched Geometry Effect
    @Namespace var animation
    
    var body: some View {
        TabView(selection: $currentTab) {
            
            HomeTabView()
                .tag(Tab.home)
            
            Text("Favorite")
                .tag(Tab.favourite)
            
            Text("Istoric")
                .tag(Tab.order)
                        
            ProfileTabNavigation(isUserLogedIn: $isUserLogedIn)
                .tag(Tab.profile)
        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 5))
                .background(
                    MaterialEffect(style: .systemThinMaterial)
                )
            },
            alignment: .bottom
        ).ignoresSafeArea(.all, edges: .bottom)
        
    }
    
    // Tab Button
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }) {
                VStack(spacing: 4) {
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: currentTab == tab ? 25 : 20, height: currentTab == tab ? 25 : 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(currentTab == tab ? Color("MainColor") : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .systemMaterial)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            })
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -25 : 0)
                    
                    if currentTab != tab {
                        Text(LocalizedStringKey(tab.tabName))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
        }.frame(height: 25)
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar()
//    }
//}

// Tab Bar enums
enum Tab: String, CaseIterable {
    case home = "house"
    case favourite = "bookmark"
    case order = "cart"
    case profile = "person"
    
    var tabName: String {
        switch self {
        case .home:
            return "HomeTabBar"
        case .favourite:
            return "FavouriteTabBar"
        case .order:
            return "OrderTabBar"
        case .profile:
            return "ProfileTabBar"
        }
    }
}

// Safe Area
extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}
