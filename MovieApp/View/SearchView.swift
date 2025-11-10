//
//  SearchView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 7.11.2025.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SearchBarView(
                    text: $viewModel.searchQuery,
                    onClear: { viewModel.searchQuery = "" }
                )
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if viewModel.searchQuery.isEmpty {
                        Text("Start typing to search for a movie")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    } else if !viewModel.searchQuery.isEmpty && viewModel.searchResults.isEmpty {
                        Text("No results found for \"\(viewModel.searchQuery)\"")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                    
                    } else {
                        MovieGridView(movies: viewModel.searchResults)
                    }
                }
            }
        }
        .navigationTitle("Search")
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
