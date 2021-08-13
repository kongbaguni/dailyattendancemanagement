//
//  Date+Extensions.swift
//  dailyattendancemanagement
//
//  Created by Changyul Seo on 2021/08/10.
//

import Foundation
extension Date {
    static var zero:Date {
        Date(timeIntervalSince1970: 0)
    }
    
    /** 포메팅 한 문자열 반환*/
    func formatedString(format:String)->String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
