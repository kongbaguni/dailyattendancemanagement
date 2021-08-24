//
//  LoginLogModel.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/24.
//

import Foundation
import RealmSwift
import CoreLocation

class LoginLogModel: Object {
    @objc dynamic var uid:String = ""
    @objc dynamic var timeIntervalSince1970:Double = 0
    @objc dynamic var location:LocationModel? = nil
}

extension LoginLogModel {
    var date:Date {
        return Date(timeIntervalSince1970: timeIntervalSince1970)
    }    
}


