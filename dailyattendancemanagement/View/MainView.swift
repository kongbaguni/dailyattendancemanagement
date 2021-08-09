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
            Text("Hello, World!")
            Button("sign out") {
                AuthManager.shared.signOut()
                viewRouter.currentView = .login
            }
        }.onAppear(perform: {
            
            print(ProfileModel.current?.name ?? "이름없음")
            print(ProfileModel.current?.email ?? "프로필 이미지 없음")
        })
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
