//
//  SigninWithApple.swift
//  firebaseTest
//
//  Created by Changyul Seo on 2020/06/09.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI

class SigninWithApple: NSObject {
    fileprivate var callback:(_ authResult:AuthDataResult?)->Void = {_ in }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    func startSignInWithAppleFlow(completed:@escaping(_ authResult:AuthDataResult?)->Void) {
        callback = completed
        let nonce:String = .randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
   
}

extension SigninWithApple : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
        callback(nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                let msg = "Invalid state: A login callback was received, but no login request was sent."
                debugPrint(msg)
                fatalError(msg)
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                let msg = "Unable to fetch identity token"
                debugPrint(msg)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                let msg = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                debugPrint(msg)
                return
            }
            
            
            // Initialize a Firebase credential.
            let credential : OAuthCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            // Sign in with Firebase.
            
            Auth.auth().signIn(with: credential) {[weak self](authResult, error) in
                if let err = error {
                    debugPrint(err.localizedDescription)
                    self?.callback(nil)
                    return
                }
                ProfileModel.currentEmail = authResult?.email
                
                self?.callback(authResult)
            }
        }
    }
}

extension SigninWithApple : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!        
    }
    
}
