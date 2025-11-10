//
//  MainTabView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 7.11.2025.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                FavoritesView(authViewModel: authViewModel)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(Color("appPrimaryRed"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.dark)
}
