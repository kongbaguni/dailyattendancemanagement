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
}
