//
//  AuthManager.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthManager: NSObject, ObservableObject {

    // MARK: - Properties
    @Environment(\.keychain) var keychain
    @Published var isUserLoggedIn = false
    // MARK: - Initialization

    override init() {
        super.init()
        setupAuthStateChangeListener()
    }

    // MARK: - Methods

    // MARK: Auth State Change Listener

    /// Sets up the authentication state change listener to track user login status.
    private func setupAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isUserLoggedIn = user != nil
//            }
        }
    }

    // MARK: Sign Out

    /// Signs out the current user.
    /// - Parameter completion: Closure called upon completion with an optional error.
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }
}

// MARK: - Account Creation and Sign In

extension AuthManager {

    // MARK: Create Account

    /// Creates a new user account with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's desired password.
    ///   - completion: Closure called upon completion with an optional error.
    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: Sign In with Email and Password

    /// Signs in the user with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's password.
    ///   - completion: Closure called upon completion with an optional error.
    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func checkIfUserExists(email: String, password: String, completion: @escaping (Error?) -> Void) {
        let usersCollection = Firestore.firestore().collection("users")
        
        // Query for documents where the "email" field matches the given email
        usersCollection.whereField("email", isEqualTo: email).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error checking if user exists: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            // Check if any document was found
            if let snapshot = snapshot, !snapshot.isEmpty {
                self?.signInWithEmail(withEmail: email, password: password, completion: { [weak self] error in
                    print("User found.")
                    self?.getUserInfo(email: email)
                    completion(error)
                })
            } else {
                self?.createAccount(withEmail: email, password: password, completion: { error in
                    self?.pushUserInfo(email: email, password: password, id: Auth.auth().currentUser?.uid ?? "")
                    completion(error)
                })
            }
        }
    }
    
    func pushUserInfo(email: String, password: String, id: String) {
        // Define the data to save
        let userData: [String: Any] = [
            "id": id,
            "email": email,
            "password": password
        ]
        
        // Add a document to the "users" collection with an auto-generated ID
        Firestore.firestore().collection("users").addDocument(data: userData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                self.keychain.set(password, key: email)
                UsersModel.saveUserInfoLocaly(id: id, email: email, passwordKey: email)
                print("User data saved with auto-generated ID!")
            }
        }
    }

    func getUserInfo(email: String) {
        let usersCollection = Firestore.firestore().collection("users")

        usersCollection.whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error checking if user exists: \(error.localizedDescription)")
                return
            }
            
            // Check if any document was found
            if let snapshot = snapshot, !snapshot.isEmpty {
                guard  let id = snapshot.documents.first?["id"] as? String,
                       let email = snapshot.documents.first?["email"] as? String,
                       let password = snapshot.documents.first?["password"] as? String
                else {
                    print("Missing or invalid data in document")
                    return
                }
                self.keychain.set(password, key: email)
                UsersModel.saveUserInfoLocaly(id: id, email: email, passwordKey: email)
            }
        }
    }
}
