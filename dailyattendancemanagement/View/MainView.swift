//
//  MainView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI
import FirebaseAuth
struct MainView: View {
    @EnvironmentObject private var viewRouter: ViewRouter

    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("sign out") {
                AuthManager.shared.signOut()
                viewRouter.currentView = .login
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
