//
//  dailyattendancemanagementApp.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/05.
//

import SwiftUI
import Firebase

fileprivate class YourAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
      return AppAttestProvider(app: app)
  }
}


@main
struct dailyattendancemanagementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewRouter = ViewRouter()

    init() {
        let providerFactory = YourAppCheckProviderFactory()        
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(viewRouter)
        }
    }
}
