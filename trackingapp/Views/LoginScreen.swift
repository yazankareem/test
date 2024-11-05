//
//  ContentView.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import SwiftUI
import CoreData

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Email Text Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Password Secure Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sign In Button
            Button(action: {
                guard validateCredentials(email: email, password: password) else { return }
                isSigningIn = true
                authManager.checkIfUserExists(email: email, password: password, completion: { error in
                    handleAuthenticationResult(error)
                    isSigningIn = false
                })
            }) {
                if isSigningIn {
                    ProgressView()
                } else {
                    Text("Sign In")
                }
            }
            .frame(width: 200, height: 40)
            .background(Color.black)
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 10)
        .navigationTitle("Sign In")
    }
    
    // MARK: - Handle Authentication Result
    
    private func handleAuthenticationResult(_ error: Error?) {
        if let error = error {
            // Handle sign-in error
            print("Sign-in error: \(error.localizedDescription)")
        } else {
            print("Signed in successfully!")
        }
        // Show result
    }
}

private func validateCredentials(email: String, password: String) -> Bool {
    return !email.isEmpty && !password.isEmpty
}

#Preview {
    LoginScreen()
}
