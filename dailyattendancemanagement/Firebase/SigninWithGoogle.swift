//
//  SigninWithGoogleId.swift
//  AccountBook
//
//  Created by Changyul Seo on 2020/07/06.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase
import SwiftUI
import FirebaseAuth

struct GoogleSignIn {
    static func signin(complete:@escaping(_ isSucess:Bool)->Void) {
        guard let clientId = FirebaseApp.app()?.options.clientID ,
              let vc = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(with: .init(clientID: clientId), presenting: vc) { user, error in
            if let err = error {
                debugPrint(err.localizedDescription)
                complete(false)
                return
            }
            guard let accessToken = user?.authentication.accessToken, let idToken = user?.authentication.idToken else {
                complete(false)
                return
            }
            KeyChainUtill.shared.googleAuthData = .init(accessToken: accessToken, idToken: idToken)

            
            let credential : OAuthCredential = OAuthProvider.credential(withProviderID: "google.com", accessToken: accessToken)
            let auth = Auth.auth()
            auth.signIn(with: credential) { result, error in
                print(auth.currentUser?.uid ?? "UID 없다")
                if let uid = Auth.auth().currentUser?.uid,
                   let email = user?.profile?.email,
                   let name = user?.profile?.name,
                   let photoURL = user?.profile?.imageURL(withDimension: 0)?.absoluteString {
                    ProfileModel.update(uid: uid, email: email, name: name, profileImageURL: photoURL, nameColor: nil)
                    complete(true)
                    return
                }
                complete(false)
            }
        }
    }
}
