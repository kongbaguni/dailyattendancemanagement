//
//  MainView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI
import FirebaseAuth
import RxRealm
import RxSwift
import RealmSwift
import SDWebImageSwiftUI

struct MainView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
        
    let disposeBag = DisposeBag()
    var body: some View {
        NavigationView {
            List {
                NavigationLink("profile-title".localized, destination: ProfileEditView())
                Button("signOut-title".localized) {
                    AuthManager.shared.signOut()
                    viewRouter.currentView = .login
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("home-title".localized,displayMode: .large)
        }.listRowBackground(
            Image("naviBg").resizable().centerCropped().opacity(0.5).colorMultiply(.init(.sRGB, red: 0.5, green: 0.5, blue: 0.0, opacity: 0.5))
           )
        
        .navigationViewStyle(StackNavigationViewStyle())
        

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView()
                .previewDevice("iPad Air (4th generation)")
        }
        .preferredColorScheme(.dark)
    }
}
