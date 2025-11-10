//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let movieService = MovieService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authViewModel: AuthViewModel) {
        
        authViewModel.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                
                let favoriteIDs = user?.favorites ?? []
                
                self.fetchFavoriteMovies(ids: favoriteIDs)
            }
            .store(in: &cancellables)
    }
    
    private func fetchFavoriteMovies(ids: [Int]) {
        guard !ids.isEmpty else {
            self.favoriteMovies = []
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            var movies: [Movie] = []
            var lastError: String?
            
            do {
                for id in ids {
                    let detail = try await movieService.fetchMovieDetail(movieId: id)
                    
                    let movie = Movie(
                        id: detail.id,
                        title: detail.title,
                        overview: detail.overview,
                        posterPath: detail.posterPath,
                        voteAverage: detail.voteAverage,
                        releaseDate: detail.releaseDate
                    )
                    movies.append(movie)
                }
                
                self.favoriteMovies = movies
                
            } catch {
                lastError = "Failed to fetch one or more favorites: \(error.localizedDescription)"
            }
            
            if !movies.isEmpty {
                self.favoriteMovies = movies
            }
            
            if let lastError = lastError, movies.isEmpty {
                self.errorMessage = lastError
            }
            
            self.isLoading = false
        }
    }
}
