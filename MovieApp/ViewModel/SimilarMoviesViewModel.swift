//
//  SmilerMoviesViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

@MainActor
class SimilarMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    
    private var movieService: MovieService
    
    private let movieId: Int
    
    init(movieId: Int, movieService: MovieService = MovieService()) {
        self.movieService = movieService
        self.movieId = movieId
    }
    
    func fetchSimilarMovies() async {
        self.errorMessage = nil
        
        do {
            self.movies = try await movieService.fetchSimilarMovies(movieId: self.movieId)
        }catch {
            self.errorMessage = "Failed to fetch similar movies: \(error.localizedDescription)"
        }
    }
}
