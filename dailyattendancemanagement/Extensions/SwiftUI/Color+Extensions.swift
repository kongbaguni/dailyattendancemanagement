//
//  Color+Extensions.swift
//  AnyReview
//
//  Created by Changyul Seo on 2020/06/16.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif


extension Color {
    static var backgroundColor:Color {
        Color("backgroundColor")
    }
    
    static var strongTextColor:Color {
        Color("strongTextColor")
    }
    
    /** RGBA 값을 얻어옵니다.*/
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
         #if canImport(UIKit)
         typealias NativeColor = UIColor
         #elseif canImport(AppKit)
         typealias NativeColor = NSColor
         #endif

         var r: CGFloat = 0
         var g: CGFloat = 0
         var b: CGFloat = 0
         var o: CGFloat = 0

         guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
             // You can handle the failure here as you want
             return (0, 0, 0, 0)
         }

         return (r, g, b, o)
     }
    
    /** rgba 값을 비교하여 차이가 가장 큰 값을 리턴합니다. 두가지 색이 비슷한 색인지 알기 위함.*/
    func compare(color:Color)->CGFloat {    
        let a = components
        let b = color.components
        
        let red = abs(a.red - b.red)
        let green = abs(a.green - b.green)
        let blue = abs(a.blue - b.blue)
        let opacity = abs(a.opacity - b.opacity)
        
        let arr = [red,green,blue,opacity]
        let new = arr.sorted()
        return new.last!
    }
}
