//
//  ProfileView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showingLogoutAlert = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.gray.opacity(0.7))
                    
                    VStack {
                        if let user = authViewModel.currentUser {
                            Text(user.fullName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(user.email)
                                .font(.body)
                                .foregroundColor(.secondary)
                        } else {
                            ProgressView()
                                .padding(10)
                            Text("Loading user data...")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("appPrimaryRed"))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out of your account?")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
