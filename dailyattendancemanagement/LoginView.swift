//
//  LoginView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewRouter: ViewRouter

    let signInWithApple = SigninWithApple()
    
    var body: some View {
        VStack{            
            Spacer(minLength: 10)
            Text("일일 근태 관리")
                .font(.title)
                .foregroundColor(.white)
                .shadow(color: .blue, radius: 10, x: 0.0, y: 0.5)
            Spacer(minLength: 10)
            Button("Signin with Apple Id") {
                self.signInWithApple.startSignInWithAppleFlow { didSucess in
                    if didSucess {
                        self.viewRouter.currentView = .main
                    }
                }
            }
            Button("Signin with Google") {
                
            }
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.backgroundColor,.blue,.green,.backgroundColor]),
                startPoint: .top,
                endPoint: .bottom))
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            
    }
}
