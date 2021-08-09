//
//  AuthDataResult+Extensions.swift
//  firebaseTest
//
//  Created by Changyul Seo on 2020/03/04.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import Foundation
import FirebaseAuth

extension AuthDataResult {
    var name:String? {
        return additionalUserInfo?.profile?["name"] as? String 
    }
    var email:String? {
        return additionalUserInfo?.profile?["email"] as? String
    }
    
    var pictureURL:String? {
        return additionalUserInfo?.profile?["picture"] as? String
    }
        
}
