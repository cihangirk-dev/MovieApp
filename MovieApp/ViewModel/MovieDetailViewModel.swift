//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    
    @Published var movieDetail: MovieDetail?
    @Published var cast: [CastMember] = []
    @Published var trailerUrl: URL?
    @Published var errorMessage: String?
    
    private let movieService: MovieService
    
    private let movieId: Int
    
    init(movieId: Int, movieService: MovieService = MovieService()) {
        self.movieId = movieId
        self.movieService = movieService
    }
    
    var castDisplayString: String {
        return cast
            .prefix(5)
            .map { $0.name }
            .joined(separator: ", ")
    }
    
    func fetchDetails() async {
        self.errorMessage = nil
        
        async let movieDetailTask = movieService.fetchMovieDetail(movieId: self.movieId)
        async let castTask = movieService.fetchCredits(movieId: self.movieId)
        async let videosTask = movieService.fetchVideos(movieId: self.movieId)
        
        do{
            self.movieDetail = try await movieDetailTask
            self.cast = try await castTask
            
            let videos = try await videosTask
            let officialTrailer = videos.first(where: { $0.type == "Trailer"})
            
            self.trailerUrl = officialTrailer?.youtubeURL
            
        }catch {
            self.errorMessage = "Failed to fetch details: \(error.localizedDescription)"
        }
    }
}
