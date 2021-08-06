//
//  RootView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI

enum AppView {
    case ready, login, main
}

class ViewRouter: ObservableObject {
    // here you can decide which view to show at launch
    @Published var currentView: AppView = .ready
}

struct RootView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentView {
        case .ready:            
            ReadyView().onAppear(perform: {
                AuthManager.shared.autoSignIn { result in
                    if result == nil {
                        viewRouter.currentView = .login
                    } else {
                        viewRouter.currentView = .main
                    }
                }
            })
        case .login:
            LoginView()
        case .main:
            MainView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
