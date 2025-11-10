//
//  ContentView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    @State private var currentAuthScreen: AuthScreen = .login
    
    enum AuthScreen {
        case login
        case register
    }
    
    var body: some View {
        if authViewModel.userSession != nil {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            NavigationStack {
                if currentAuthScreen == .login {
                    LoginView(viewModel: authViewModel, onShowRegister: {
                        currentAuthScreen = .register
                    })
                } else {
                    RegisterView(viewModel: authViewModel, onShowLogin: {
                        currentAuthScreen = .login
                    })
                }
            }
            .animation(.easeInOut, value: currentAuthScreen)
        }
    }
}

#Preview {
    ContentView()
}
