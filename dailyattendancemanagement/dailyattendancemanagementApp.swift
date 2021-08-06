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
    @StateObject private var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(viewRouter)
        }
    }
}
