//
//  AuthViewModel.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.listenToAuthState()
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func listenToAuthState() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task {
                self?.userSession = user
                
                if let user = user {
                    await self?.fetchUser(uid: user.uid)
                } else {
                    self?.currentUser = nil
                }
            }
        }
    }

    private func fetchUser(uid: String) async {
        let db = Firestore.firestore()
        do {
            let document = db.collection("users").document(uid)
            self.currentUser = try await document.getDocument(as: User.self)
            
        } catch {
            self.currentUser = nil
        }
    }
        
    func isFavorite(movieID: Int) -> Bool {
        currentUser?.favorites?.contains(movieID) ?? false
    }

    func addFavorite(movieID: Int) async {
        guard let uid = userSession?.uid else { return }
        
        currentUser?.favorites?.append(movieID)
        
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(uid).updateData([
                "favorites": FieldValue.arrayUnion([movieID])
            ])
        } catch {
            currentUser?.favorites?.removeAll(where: { $0 == movieID })
        }
    }

    func removeFavorite(movieID: Int) async {
        guard let uid = userSession?.uid else { return }
        
        currentUser?.favorites?.removeAll(where: { $0 == movieID })
        
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(uid).updateData([
                "favorites": FieldValue.arrayRemove([movieID])
            ])
        } catch {
            currentUser?.favorites?.append(movieID)
        }
    }
        
    @MainActor
    func signUp() async {
        isLoading = true
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty else {
            errorMessage = "All fields must be filled."
            isLoading = false
            return
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "fullName": fullName,
                "email": email,
                "createdAt": Timestamp(),
                "favorites": [Int]()
            ]
            
            try await db.collection("users").document(authResult.user.uid).setData(userData)
            
            isLoading = false
            
            self.fullName = ""
            self.email = ""
            self.password = ""
            
        } catch let error {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    @MainActor
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in both email and password."
            isLoading = false
            return
        }
        
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            
            isLoading = false
            
            self.email = ""
            self.password = ""
            
        } catch let error {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
}
