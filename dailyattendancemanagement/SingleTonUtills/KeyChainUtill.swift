//
//  KeyChainUtill.swift
//  lmhs
//
//  Created by Changyeol Seo on 2021/05/28.
//

import Foundation
import KeychainAccess

class KeyChainUtill {
    static let shared = KeyChainUtill()
    /** 키체인 사용 */
    var keychain:Keychain {
        let keychain = Keychain(server: "net.kongbaguni.dailyattendancemanagement", protocolType: .https)
            .label("근태관리")
            .synchronizable(true)
            .accessibility(.afterFirstUnlock)
        return keychain
    }

    func set(key:String, value:String?) {
        do {
            if let data = value {
                try keychain.set(data, key: key)
            }
            else {
                try keychain.remove(key)
            }
        } catch {
            print("keychain save error \(error.localizedDescription)")
        }
    }
    
    func get(key:String)->String? {
        do {
            return try keychain.get(key)
        } catch {
            print("keychain get error \(error.localizedDescription)")
            return nil
        }
    }
        
    
    
    struct AuthRowData {
        let accessToken:String
        let idToken:String
    }
    
    var googleAuthData : AuthRowData? {
        get {
            guard let accessToken = get(key: "auth_accessToken"),
                  let idToken = get(key: "auth_idToken")
                  else {
                return nil
            }
            return .init(accessToken: accessToken, idToken: idToken)
        }
        set {
            set(key: "auth_accessToken", value: newValue?.accessToken)
            set(key: "auth_idToken", value: newValue?.idToken)
        }
    }
    
}
