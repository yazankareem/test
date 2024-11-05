//
//  PreviousLoginsView.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 03/11/2024.
//

import Foundation
import SwiftUI
import RealmSwift

struct PreviousLoginsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var previousEmails: [String] = [] // Fetch from local storage

    var body: some View {
        NavigationView {
            List(previousEmails, id: \.self) { email in
                Text(email)
            }
            .navigationTitle("Previous Logins")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }.onAppear {
            previousEmails = UsersModel.getAllUsers()
        }
    }
}
