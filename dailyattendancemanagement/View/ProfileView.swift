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
import MapKit

struct ProfileView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentation
    
    @State var textName = "홍길동"
    @State var textNickName = "고길동"
    @State var textEmail = "hong@gil.dong"
    @State var profileUrl = "https://pbs.twimg.com/media/DxHLQMjU0AISfx0?format=jpg&name=900x900"
    @State var textLastSigninDate = "2021년 3월 6일"
    @State var locationStatus = ""
    @State var nameColor:Color = .white
    @State var nameBgColor:Color = .clear
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
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
                        Text("name-title".localized).fontWeight(.bold).foregroundColor(.yellow)
                        Text(textName)
                        Spacer()
                    }
                    HStack {
                        Text("nickname-title".localized).fontWeight(.bold).foregroundColor(.yellow)
                        TextField("inputNickName-title", text: $textNickName)
                            .padding(5)
                            .border(nameColor, width: 1)
                            .foregroundColor(nameColor)
                            .background(nameBgColor)
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                        Spacer()
                    }
                    ColorPicker("nameColor-title".localized, selection: $nameColor)
                    ColorPicker("nameBgColor-title".localized, selection: $nameBgColor)
                    HStack {
                        Text("email-title".localized).fontWeight(.bold).foregroundColor(.yellow)
                        Text(textEmail)
                        Spacer()
                    }
                    Spacer()
                }
            }
            Text(textLastSigninDate)
            Map(coordinateRegion: $region, showsUserLocation: true)
                    .frame(width: 400, height: 300)
            Text(locationStatus)
        }
        .navigationBarItems(trailing:
                                Button(action: {
                                    guard let uid = ProfileModel.currentUid else {
                                        return
                                    }
                                    ProfileModel.update(uid: uid,
                                                        email: textEmail,
                                                        name: textName,
                                                        nickname: textNickName,
                                                        profileImageURL: profileUrl,
                                                        nameColor: nameColor,
                                                        nameBgColor: nameBgColor) { error in
                                        if error == nil {
                                            presentation.wrappedValue.dismiss()
                                        }
                                    }
                                    
                                }, label: {
                                    Text("save".localized)
                                    
                                })
        )
        .navigationTitle("profile-title".localized)
        .onAppear(perform: {
            LocationManager.shared.start()

            UITextField.appearance().clearButtonMode = .whileEditing
            guard let profile = ProfileModel.current else {
                return
            }
            textName = profile.name
            textNickName = profile.nickname
            textEmail = profile.email
            profileUrl = profile.googleProfileImageUrl
            textLastSigninDate = profile.lastSigninDate.formatedString(format: "yyyy년 M월 d일 H시 m분 s초")!
            nameColor = profile.nameColor
            nameBgColor = profile.nameBgColor
            
            
            Observable.collection(from: try! Realm().objects(LocationModel.self)).subscribe { event in
                switch event {
                case .next(let locations):
                    if let location = locations.last {
                        locationStatus = "\(location.longitude) \(location.latitude)"
                        region = .init(center: location.locationCoordinate2D, latitudinalMeters: 200, longitudinalMeters: 200)
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
