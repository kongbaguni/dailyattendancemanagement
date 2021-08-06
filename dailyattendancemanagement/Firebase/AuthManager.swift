//
//  AuthManager.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    func autoSignIn(complete:@escaping(_ result:AuthDataResult?)->Void) {
        if let auth = KeyChainUtill.shared.googleAuthData {
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                complete(result)
            }
            return
        }
        complete(nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            return
        }
        
        KeyChainUtill.shared.googleAuthData = nil
    }
}
