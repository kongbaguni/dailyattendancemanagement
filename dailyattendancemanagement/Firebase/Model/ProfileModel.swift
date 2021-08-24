//
//  ProfileModel.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/09.
//

import Foundation
import RealmSwift
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class ProfileModel : Object {
    static var currentUid:String? {
        return Auth.auth().currentUser?.uid
    }
    
    @objc dynamic var uid:String = ""
    @objc dynamic var email:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var profileImageURL:String = ""
    @objc dynamic var googleProfileImageUrl:String = ""
    @objc dynamic var lastSignInTimeIntervalSince1970:Double = 0
    @objc dynamic var nameColor_red:Double = 1
    @objc dynamic var nameColor_green:Double = 1
    @objc dynamic var nameColor_blue:Double = 1
    @objc dynamic var nameColor_opacity:Double = 1

    
    var lastSigninDate:Date {
        return Date(timeIntervalSince1970: lastSignInTimeIntervalSince1970)
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
    
extension ProfileModel {
    var nameColor:Color {
        return .init(.sRGB, red: nameColor_red, green: nameColor_green, blue: nameColor_blue, opacity: nameColor_opacity)
    }
    
    static var current:ProfileModel? {
        if let id = currentUid {
            return try! Realm().object(ofType: ProfileModel.self, forPrimaryKey: id)
        }
        return nil
    }

    static func update(uid:String, email:String, name:String, profileImageURL:String?, nameColor:Color?) {
        var data:[String:AnyHashable] = [
            "uid":uid,
            "email":email,
            "name":name,
            "lastSignInTimeIntervalSince1970":Date().timeIntervalSince1970
        ]
        if let url = profileImageURL {
            data["googleProfileImageUrl"] = url
        }
        if let color = nameColor {
            data["nameColor_red"] = color.components.red
            data["nameColor_green"] = color.components.green
            data["nameColor_blue"] = color.components.blue
            data["nameColor_opacity"] = color.components.opacity
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.create(ProfileModel.self, value: data, update: .modified)
        }
        
        
        let profile = Firestore.firestore().collection("profile")        
        profile.document(uid).updateData(data) { error in
            if error != nil {
                profile.document(uid).setData(data) { error in
                    
                }
            }
        }
    }
    

}
