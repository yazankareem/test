//
//  DDDD.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import Foundation


class DDDD {
    @Published var isUserLoggedIn = false
    let d = AuthManager()
    
    
    func signIn(email: String, password: String) {
        d.checkIfUserExists(email: email, password: password) { error in
            <#code#>
        }
    }
}
