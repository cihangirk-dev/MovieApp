//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 7.11.2025.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
     
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let movieService: MovieService
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
        
        $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                
                if query.isEmpty {
                    self.searchResults = []
                    self.errorMessage = nil
                    self.isLoading = false
                }else {
                    Task {
                        await self.performSearch(query: query)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) async {
        self.errorMessage = nil
        self.isLoading = true
        
        do {
            let newMovies = try await movieService.searchMovies(query: query)
            self.searchResults = newMovies
        }catch {
            self.errorMessage = "Failed to search movies: \(error.localizedDescription)"
            self.searchResults = []
        }
        self.isLoading = false
    }
}
