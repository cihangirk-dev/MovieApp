//
//  FavoritesView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject private var viewModel: FavoritesViewModel
    
    init(authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(authViewModel: authViewModel))
    }
    
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
            
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.favoriteMovies.isEmpty {
                    Text("You haven't added any favorites yet.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    MovieGridView(movies: viewModel.favoriteMovies)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let tempAuth = AuthViewModel()
    return NavigationStack {
        FavoritesView(authViewModel: tempAuth)
            .environmentObject(tempAuth)
            .preferredColorScheme(.dark)
    }
}
