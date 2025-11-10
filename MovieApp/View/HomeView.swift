//
//  HomeView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
          
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
                    
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            MovieGridView(movies: viewModel.movies, onLastItemAppeared: {
                                Task { await viewModel.fetchMoreMovies() }
                            })
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        } header: {
                            HStack(spacing: 8) {
                                ForEach(MovieEndpoint.allCases, id: \.self) { endpoint in
                                    Button {
                                        viewModel.selectedEndpoint = endpoint
                                    } label: {
                                        Text(endpoint.displayName)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .background(
                                                viewModel.selectedEndpoint == endpoint ?
                                                    Color("appPrimaryRed") : Color.gray.opacity(0.25)
                                            )
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color("appBackground"))
                        }
                    }
                    .id("top")
                }
                .overlay {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .onChange(of: viewModel.selectedEndpoint) {
                    withAnimation {
                        viewModel.categoryDidChange()
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        .navigationTitle("Movie App")
        .preferredColorScheme(.dark)
        .task {
            if viewModel.movies.isEmpty {
                viewModel.categoryDidChange()
            }
        }
    }
}

extension MovieEndpoint {
    var displayName: String {
        self.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
