//
//  MovieService.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

enum MovieEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular
    case upcoming
    
    var path: String {
        return "/movie/\(self.rawValue)"
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingError
    case unknownError
}

class MovieService {
    
    func fetchMovies(from endpoint: MovieEndpoint, page: Int) async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)\(endpoint.path)?api_key=\(Constants.apiKey)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            
            return movieResponse.results
        }catch is Swift.DecodingError {
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        let urlString = "\(Constants.baseURL)/movie/\(movieId)?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movieDetail = try decoder.decode(MovieDetail.self, from: data)
            
            return movieDetail
        }catch is Swift.DecodingError{
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func fetchCredits(movieId: Int) async throws -> [CastMember] {
        
        let urlString = "\(Constants.baseURL)/movie/\(movieId)/credits?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let creditResponse = try decoder.decode(CreditsResponse.self, from: data)
            
            return creditResponse.cast
        }catch is Swift.DecodingError {
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func fetchVideos(movieId: Int) async throws -> [Video] {
        
        let urlString = "\(Constants.baseURL)/movie/\(movieId)/videos?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let videoResponse = try decoder.decode(VideoResponse.self, from: data)
            
            return videoResponse.results
        }catch is Swift.DecodingError {
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func fetchSimilarMovies(movieId: Int) async throws -> [Movie] {
        
        let urlString = "\(Constants.baseURL)/movie/\(movieId)/similar?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            
            return movieResponse.results
        }catch is Swift.DecodingError {
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    func searchMovies(query: String) async throws -> [Movie]{
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.apiKey)&query=\(encodedQuery)&page=1"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            
            return movieResponse.results
        }catch is Swift.DecodingError {
            throw NetworkError.decodingError
        }catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
