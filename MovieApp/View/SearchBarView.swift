//
//  SearchBarView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 6.11.2025.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    
    var onClear: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search for a movie", text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}
