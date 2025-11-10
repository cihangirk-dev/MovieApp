//
//  MoviePosterView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import SwiftUI
import NukeUI

struct MoviePosterView: View {
    
    let movie: Movie
    
    var body: some View {
        
        LazyImage(url: movie.posterUrl) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }else if state.error != nil {
                ZStack{
                    Color.gray.opacity(0.3)
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
            }else {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

extension Movie {
    var posterUrl: URL? {
        guard let posterPath = posterPath else {return nil}
        return URL(string: "\(Constants.imageBaseURL)\(posterPath)")
    }
}


#Preview {
    MoviePosterView(movie: Movie(
        id: 1,
        title: "Fake Movie",
        overview: "This is a fake movie description.",
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        voteAverage: 8.8,
        releaseDate: "2025-10-29"
    ))
}
