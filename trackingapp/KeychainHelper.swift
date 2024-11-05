//
//  KeychainHelper.swift
//  trackingapp
//
//  Created by Yazan Ahmad on 04/11/2024.
//

import KeychainSwift
import SwiftUI

final class KeychainManager {
    let keychain: KeychainSwift
    
    init() {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        self.keychain = keychain
    }
    
    func set(_ value: String, key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(_ key: String) -> String? {
        keychain.get(key)
    }
}

struct KeychainManagerKey: EnvironmentKey {
    static let defaultValue: KeychainManager = KeychainManager()
}

extension EnvironmentValues {
    var keychain: KeychainManager {
        get { self[KeychainManagerKey.self] }
        set { self[KeychainManagerKey.self] = newValue }
    }
}
