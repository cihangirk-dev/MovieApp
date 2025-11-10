//
//  MovieGridView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 6.11.2025.
//

import SwiftUI

struct MovieGridView: View {
    
    let movies: [Movie]
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var onLastItemAppeared: (() -> Void)? = nil
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MoviePosterView(movie: movie)
                        .shadow(radius: 4)
                }
                .buttonStyle(.plain)
                .onAppear {
                    if movie.id == movies.last?.id {
                        onLastItemAppeared?()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
