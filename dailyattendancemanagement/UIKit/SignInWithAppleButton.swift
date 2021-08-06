//
//  SignInWithAppleButton.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI
import AuthenticationServices

final class SignInWithAppleButton : UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {        
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
