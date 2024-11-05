//
//  UsersModel.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import Foundation
import RealmSwift
import FirebaseAuth


class UsersModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var email: String
    @Persisted var passwordKey: String
    
    static func saveUserInfoLocaly(id: String, email: String, passwordKey: String) {
        let realm = try! Realm()
        
        let usersModel = UsersModel()
        usersModel.id = id
        usersModel.email = email
        usersModel.passwordKey = passwordKey
        try! realm.write {
            realm.add(usersModel, update: .all)
        }
        
        print("Location history saved to Realm.")
    }
    
    static func getAllUsers() -> [String] {
        let realm = try! Realm()
        let allUser = realm.objects(UsersModel.self)
        return allUser.map { $0.email }
    }
}
