//
//  ProfileView.swift
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

struct ProfileView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State var textName = "홍길동"
    @State var textEmail = "hong@gil.dong"
    @State var profileUrl = "https://pbs.twimg.com/media/DxHLQMjU0AISfx0?format=jpg&name=900x900"
    @State var textLastSigninDate = "2021년 3월 6일"
    @State var locationStatus = ""
    @State var nameColor:Color = .white
    
    let disposeBag = DisposeBag()
    var body: some View {
        List{
            HStack {
                VStack {
                    WebImage(url: URL(string: profileUrl))
                        .resizable(capInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0), resizingMode: .stretch)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(nameColor, width: 2)
                    Spacer()
                }
                VStack {
                    HStack {
                        Text("name").fontWeight(.bold).foregroundColor(.yellow)
                        ColorPicker(textName, selection: $nameColor).foregroundColor(nameColor)
                        Spacer()
                    }
                    HStack {
                        Text("email").fontWeight(.bold).foregroundColor(.yellow)
                        Text(textEmail)
                        Spacer()
                    }
                    Spacer()
                }
            }
            Text(textLastSigninDate)
            Text(locationStatus)
            Button("sign out") {
                AuthManager.shared.signOut()
                viewRouter.currentView = .login
            }
        }
        .navigationTitle("profile")
        .onAppear(perform: {
            LocationManager.shared.start()

            guard let profile = ProfileModel.current else {
                return
            }
            textName = profile.name
            textEmail = profile.email
            profileUrl = profile.googleProfileImageUrl
            textLastSigninDate = profile.lastSigninDate.formatedString(format: "yyyy년 M월 d일 H시 m분 s초")!
            
            Observable.collection(from: try! Realm().objects(LocationModel.self)).subscribe { event in
                switch event {
                case .next(let locations):
                    if let location = locations.last {
                        locationStatus = "\(location.longitude) \(location.latitude)"
                    }
                default:
                    break
                }
                
            }.disposed(by: disposeBag)
            
            Observable.collection(from: try! Realm().objects(ProfileModel.self)).subscribe { event in
                switch event {
                case .next(let list):
                    if let profile = list.last {
                        print(profile.name)
                    }
                    break
                default:
                    break
                }
            }.disposed(by: disposeBag)
            if let color = ProfileModel.current?.nameColor {
                nameColor = color
            }
            print(ProfileModel.current?.name ?? "이름없음")
            print(ProfileModel.current?.email ?? "프로필 이미지 없음")
        })
        .onDisappear(perform: {
            print("!!!")
            guard let uid = ProfileModel.currentUid else {
                return
            }
            ProfileModel.update(uid: uid, email: textEmail, name: textName, profileImageURL: profileUrl, nameColor: nameColor)
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView()
            ProfileView()
                .previewDevice("iPad Air (4th generation)")
        }
        .preferredColorScheme(.dark)
    }
}
