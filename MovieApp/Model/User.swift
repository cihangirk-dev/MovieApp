//
//  User.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import Foundation
import FirebaseFirestore

// Identifiable, Codable
struct User: Identifiable, Codable {
    
    @DocumentID var id: String?
    
    let fullName: String
    let email: String
    let createdAt: Timestamp
    
    // YENİ: Favori film ID'lerini saklamak için
    // 'let' yerine 'var' yaptık, çünkü bu alan güncellenecek
    var favorites: [Int]? // Film ID'leri listesi (opsiyonel)
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullName"
        case email = "email"
        case createdAt = "createdAt"
        case favorites = "favorites" // Yeni alanı ekledik
    }
}
