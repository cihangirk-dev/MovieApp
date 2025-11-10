//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie
    
    @StateObject private var viewModel: MovieDetailViewModel
    @State private var showingAlert = false
    @Environment(\.openURL) var openURL
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    init(movie: Movie) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movie.id))
    }
    
    var body: some View {
        ScrollView {
            if let detail = viewModel.movieDetail {
                VStack(alignment: .leading, spacing: 16) {
                    MoviePosterView(movie: movie)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text(detail.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        
                        if let releaseDate = detail.releaseDate, !releaseDate.isEmpty {
                                Text(String(releaseDate.prefix(4)))
                                .font(.title)
                        }
                    }
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color("appStarYellow"))
                            Text(String(format: "%.1f", detail.voteAverage))
                        }
                        Spacer()
                        
                        if let runtime = detail.runtime, runtime > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(.white)
                                Text("\(runtime) min.")
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    HStack {
                        ForEach(detail.genres ?? [], id: \.id) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    
                    Text(detail.overview)
                        .font(.body)
                    
                    if !viewModel.cast.isEmpty {
                        Text("Cast: ")
                            .font(.headline)
                            .fontWeight(.bold)
                        +
                        Text(viewModel.castDisplayString)
                            .font(.body)
                    }
                    HStack{
                        NavigationLink(destination: SimilarMoviesView(movieId: movie.id)) {
                            Label("Similar Movies", systemImage: "film.stack.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .padding()
                                .background(Color("appSecondaryBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            if let url = viewModel.trailerUrl {
                                openURL(url)
                            }else {
                                showingAlert = true
                            }
                        } label: {
                            Label("Watch Trailer", systemImage: "play.rectangle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .padding()
                                .background(Color("appPrimaryRed"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }else {
                ProgressView()
                    .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .alert("Trailer Not Found", isPresented: $showingAlert){
                Button("OK", role: .cancel) { }
        }message: {
            Text("A trailer for this movie could not be found.")
        }
        .task {
            await viewModel.fetchDetails()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if authViewModel.isFavorite(movieID: movie.id) {
                            await authViewModel.removeFavorite(movieID: movie.id)
                        } else {
                            await authViewModel.addFavorite(movieID: movie.id)
                        }
                    }
                } label: {
                    Image(systemName: authViewModel.isFavorite(movieID: movie.id) ? "heart.fill" : "heart")
                        .foregroundColor(Color("appPrimaryRed"))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 550,
                title: "Fight Club",
                overview: "A ticking-time-bomb insomn...",
                posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
                voteAverage: 8.4,
                releaseDate: "1999-10-15"
            )
        )
        .environmentObject(AuthViewModel())
    }
}
