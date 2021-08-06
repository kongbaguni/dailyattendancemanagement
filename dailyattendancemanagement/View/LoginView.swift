//
//  LoginView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI
import Lottie

struct LoginView: View {
    @EnvironmentObject private var viewRouter: ViewRouter

    let signInWithApple = SigninWithApple()
    
    var body: some View {
        VStack{            
            Spacer(minLength: 10)
            Text("일일 근태 관리")
                .font(.title)
                .foregroundColor(.backgroundColor)
                .shadow(color: .backgroundColor, radius: 30, x: 0.0, y: 0.5)
            LottieView(filename: "lottie/work")
                .frame(
                      minWidth: 100,
                      maxWidth: .infinity,
                      minHeight: 200,
                      maxHeight: 300,
                      alignment: .center
                    )

            Spacer(minLength: 10)
            SignInWithAppleButton().frame(width: 140, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).onTapGesture {
                self.signInWithApple.startSignInWithAppleFlow { result in
                    if let result = result {
                        self.viewRouter.currentView = .main
                        print(result)                                                                        
                    }
                }
            }
            Button("Signin with Google") {
                GoogleSignIn.signin { isSucess in
                    if isSucess {
                        self.viewRouter.currentView = .main
                    }                    
                }
            }
            Image(uiImage: #imageLiteral(resourceName: "logo-built_white"))
                .resizable()
                .frame(width: 100, height: 40, alignment: .bottomTrailing)
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
            .preferredColorScheme(.light)
            
    }
}
