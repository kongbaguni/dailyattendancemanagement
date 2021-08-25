//
//  LocationModel.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/24.
//

import Foundation
import RealmSwift
import CoreLocation

class LocationModel: Object {
    @objc dynamic var timeIntervalSince1970:Double = 0
    @objc dynamic var latitude:Double = 0
    @objc dynamic var longitude:Double = 0
}


extension LocationModel {
    var locationCoordinate2D:CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
    static func create(location:CLLocation) {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(realm.objects(LocationModel.self))
            realm.create(LocationModel.self, value: [
                "timeIntervalSince1970" : Date().timeIntervalSince1970,
                "latitude" : location.coordinate.latitude,
                "longitude" : location.coordinate.longitude
            ])
        }
    }
}
