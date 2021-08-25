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
    @objc dynamic var nickname:String = ""
    @objc dynamic var profileImageURL:String = ""
    @objc dynamic var googleProfileImageUrl:String = ""
    @objc dynamic var lastSignInTimeIntervalSince1970:Double = 0
    @objc dynamic var nameColor_red:Double = 1
    @objc dynamic var nameColor_green:Double = 1
    @objc dynamic var nameColor_blue:Double = 1
    @objc dynamic var nameColor_opacity:Double = 1
    @objc dynamic var nameBgColor_red:Double = 1
    @objc dynamic var nameBgColor_green:Double = 1
    @objc dynamic var nameBgColor_blue:Double = 1
    @objc dynamic var nameBgColor_opacity:Double = 1

    
    var lastSigninDate:Date {
        return Date(timeIntervalSince1970: lastSignInTimeIntervalSince1970)
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
    
extension ProfileModel {
    
    var nameValue:String {
        if nickname.isEmpty == false {
            return nickname
        }
        return name
    }
    
    var nameColor:Color {
        .init(.sRGB, red: nameColor_red, green: nameColor_green, blue: nameColor_blue, opacity: nameColor_opacity)
    }
    
    var nameBgColor:Color {
        .init(.sRGB, red: nameBgColor_red, green: nameBgColor_green, blue: nameBgColor_blue, opacity: nameBgColor_opacity)
    }
    
    static var current:ProfileModel? {
        if let id = currentUid {
            return try! Realm().object(ofType: ProfileModel.self, forPrimaryKey: id)
        }
        return nil
    }
    
    func getDataFromFireStore(complete:@escaping()->Void) {
        Firestore.firestore().collection("profile").document(uid).getDocument { snapShot, error in
            if let data = snapShot?.data() {
                let realm = try! Realm()
                try! realm.write {
                    realm.create(ProfileModel.self, value: data, update: .modified)
                    complete()
                }
            }
        }        
    }

    static func update(uid:String, email:String, name:String?, nickname:String? = nil, profileImageURL:String? = nil , nameColor:Color? = nil, nameBgColor:Color? = nil, complete:@escaping(_ error:Error?)->Void) {
        var data:[String:AnyHashable] = [
            "uid":uid,
            "email":email,
            "lastSignInTimeIntervalSince1970":Date().timeIntervalSince1970
        ]
        if let name = name {
            data["name"] = name
        }
        
        if let name = nickname {
            data["nickname"] = name
        }
        
        if let url = profileImageURL {
            data["googleProfileImageUrl"] = url
        }
        
        if let color = nameColor {
            data["nameColor_red"] = color.components.red
            data["nameColor_green"] = color.components.green
            data["nameColor_blue"] = color.components.blue
            data["nameColor_opacity"] = color.components.opacity
        }
        
        if let color = nameBgColor {
            data["nameBgColor_red"] = color.components.red
            data["nameBgColor_green"] = color.components.green
            data["nameBgColor_blue"] = color.components.blue
            data["nameBgColor_opacity"] = color.components.opacity
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.create(ProfileModel.self, value: data, update: .modified)
        }
        
        
        let profile = Firestore.firestore().collection("profile")        
        profile.document(uid).updateData(data) { error in
            if let _ = error {
                profile.document(uid).setData(data) { error2 in
                    complete(error2)
                }
                return
            }
            ProfileModel.current?.getDataFromFireStore() {
                complete(nil)
            }
        }
    }
    

}
