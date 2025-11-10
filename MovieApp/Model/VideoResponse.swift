//
//  VideoResponse.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 29.10.2025.
//

import Foundation

struct VideoResponse: Decodable {
    let results: [Video]
}

struct Video: Decodable, Identifiable {
    let id: String
    let key: String?
    let name: String?
    let site: String?
    let type: String?
    
    var youtubeURL: URL? {
        guard let site = site, site == "YouTube", let key = key else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
