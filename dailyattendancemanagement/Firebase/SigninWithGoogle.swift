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
            if let accessToken = user?.authentication.accessToken, let idToken = user?.authentication.idToken {
                KeyChainUtill.shared.googleAuthData = .init(accessToken: accessToken, idToken: idToken)
            }
            complete(true)
        }
    }
}
