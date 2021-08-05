//
//  dailyattendancemanagementApp.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/05.
//

import SwiftUI
@main
struct dailyattendancemanagementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: {
                print("!!!!")
            })
        }
    }
}
