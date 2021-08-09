//
//  ProfileModel.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/09.
//

import Foundation
import RealmSwift
import FirebaseFirestore

class ProfileModel : Object {
    static var currentEmail:String? = nil
    
    @objc dynamic var email:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var profileImageUrl:String = ""
}
    
extension ProfileModel {

    static var current:ProfileModel? {
        if let email = ProfileModel.currentEmail {
            return try! Realm().object(ofType: ProfileModel.self, forPrimaryKey: email)
        }
        return nil
    }
    
    static func create(email:String,name:String) {
        
    }
    
    static func getInfo() {
        guard let email = ProfileModel.currentEmail else {
            return
        }
        let document = Firestore.firestore().collection("profile").document(email)
        document.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                let realm = try! Realm()
                try! realm.write{
                    realm.create(ProfileModel.self, value: data, update: .modified)
                }
            }
        }
    }
    
    func update(complete:@escaping()->Void) {
        let data = [
            "email":email,
            "name":name,
            "profileImageURL":profileImageUrl
        ]
        
        let document = Firestore.firestore().collection("profile").document(email)
        document.updateData(data) { error in
            
        }
    }
}
