//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var selectedEndpoint: MovieEndpoint = .nowPlaying
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieService()){
        self.movieService = movieService
    }
    
    func fetchMoreMovies() async {
        guard !isLoading, canLoadMorePages else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newMovies = try await movieService.fetchMovies(from: selectedEndpoint, page: currentPage)
            
            if newMovies.isEmpty {
                canLoadMorePages = false
                return
            }
            
            let existingIds = Set(self.movies.map{$0.id})
            let uniqueNewMovies = newMovies.filter { !existingIds.contains($0.id) }
            
            self.movies.append(contentsOf: uniqueNewMovies)
            self.currentPage += 1
            
        } catch {
            self.errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
        }
    }
    
    func categoryDidChange() {
        self.currentPage = 1
        self.canLoadMorePages = true
        self.errorMessage = nil
        self.isLoading = true
        
        Task {
            do {
                let newMovies = try await movieService.fetchMovies(from: selectedEndpoint, page: 1)
                
                self.movies = newMovies
                self.currentPage = 2
                self.canLoadMorePages = !newMovies.isEmpty
                
            } catch {
                self.errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
                self.movies = []
                self.canLoadMorePages = false
            }
            
            self.isLoading = false
        }
    }
}
