//
//  SmilerMoviesView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import SwiftUI

struct SimilarMoviesView: View {
    
    @StateObject private var viewModel: SimilarMoviesViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(movieId: Int){
        _viewModel = StateObject(wrappedValue: SimilarMoviesViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MoviePosterView(movie: movie)
                    }
                }
            }
            .padding()
            
            if viewModel.movies.isEmpty && viewModel.errorMessage == nil {
                ProgressView()
                    .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Similar Movies")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchSimilarMovies()
        }
    }
}

/*
#Preview {
    SmilerMoviesView()
}
*/
