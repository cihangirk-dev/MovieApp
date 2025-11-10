//
//  CreditsResponse.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

struct CreditsResponse: Decodable {
    let cast: [CastMember]
}

struct CastMember: Decodable, Identifiable {
    let id: Int
    let name: String
}
