//
//  ProfileEditView.swift
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

struct ProfileEditView: View {
    @EnvironmentObject private var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentation
    @State private var showingImagePicker = false
    @State private var inputImageURL: URL? = nil
    @State private var isLoading:Bool = false
    @State private var showingImageActonSheet = false
    
    @State private var errorAlert = false
    @State private var errorTitle:Text = Text("")
    @State private var errorMessage:Text = Text("")
    
    @State var displayName = "고길동"
    @State var textName = "홍길동"
    @State var textNickName = "고길동"
    @State var textEmail = "hong@gil.dong"
    @State var profileUrl = ""
    @State var textLastSigninDate = "2021년 3월 6일"
    @State var textIntroduce = ""
    @State var nameColor:Color = .white
    @State var nameBgColor:Color = .orange
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @State var isDeletePhoto = false
    
    let disposeBag = DisposeBag()
    func loadImage() {
        if let url = inputImageURL?.absoluteString {
            profileUrl = url
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            List{
                HStack {
                    GeometryReader { geometry2 in
                        WebImage(url: URL(string: profileUrl))
                            .centerCropped()
                            .border(nameColor, width: 2)
                            .onTapGesture {
                                showingImageActonSheet = true
                            }
                        
                        
                        Text(displayName)
                            .padding(10)
                            .foregroundColor(nameColor)
                            .background(nameBgColor)
                            .cornerRadius(20)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(nameColor, lineWidth: 2.5)
                            )
                            .padding(10)
                    }
                    VStack {
                        HStack {
                            "name-title".localizedText.fontWeight(.bold).foregroundColor(.yellow)
                            Text(textName)
                            Spacer()
                        }
                        HStack {
                            Text("nickname-title".localized).fontWeight(.bold).foregroundColor(.yellow)
                            TextField("inputNickName-title", text: $textNickName)
                                .padding(5)
                                .border(Color.strongTextColor, width: 1)
                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                                .onChange(of: textNickName, perform: { value in
                                    print(value)
                                    displayName = textNickName.isEmpty ? textName : textNickName
                                })
                            Spacer()
                        }
                        ColorPicker("nameColor-title".localized, selection: $nameColor)
                        ColorPicker("nameBgColor-title".localized, selection: $nameBgColor)
                        Button("nameColorSetComplementaryColor".localized) {
                            nameBgColor = nameColor.complementaryColor
                        }
                        Spacer()
                    }
                }
                HStack {
                    "email-title".localizedText.fontWeight(.bold).foregroundColor(.yellow)
                    Text(textEmail)
                    Spacer()
                }
                HStack {
                    VStack {
                        "introduce-title".localizedText.fontWeight(.bold).foregroundColor(.yellow)
                        Spacer()
                    }
                    TextEditor(text:$textIntroduce)
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 500, minHeight: 100, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    
                }
//                Text(textLastSigninDate)
//                Map(coordinateRegion: $region, showsUserLocation: true)
//                    .frame(width: geometry.size.width-15, height: 100, alignment: .center)
            }
            .progressViewStyle(CircularProgressViewStyle())
            .alert(isPresented: $errorAlert, content: {
                Alert(title: errorTitle,
                      message: errorMessage,
                      dismissButton: .cancel("confirm-title".localizedText))
            })
            .actionSheet(isPresented: $showingImageActonSheet, content: {
                ActionSheet(title: "profilePhoto-title".localizedText, message: nil, buttons: [
                    .default("selectPhoto-title".localizedText, action: {
                        showingImagePicker = true
                    }),
                    .default("deletePhoto-title".localizedText, action: {
                        inputImageURL = nil
                        profileUrl = ProfileModel.current!.googleProfileImageUrl
                        isDeletePhoto = true
                    }),
                    .cancel()
                ]
                )
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePicker(imageURL: $inputImageURL)
            })
            .navigationBarItems(
                trailing:
                    Button(action: {
                        guard let uid = ProfileModel.currentUid else {
                            return
                        }
                        
                        if nameColor == nameBgColor {
                            errorTitle = "errorAlertNameColor-title".localizedText
                            errorMessage = "errorAlertNameColor-message1".localizedText
                            errorAlert = true
                            return
                        }
                        
                        if nameColor.compare(color: nameBgColor) < 0.2 {
                            errorTitle = "errorAlertNameColor-title".localizedText
                            errorMessage = "errorAlertNameColor-message2".localizedText
                            errorAlert = true
                            return
                        }
                        
                        if nameColor.components.opacity < 0.5 {
                            errorTitle = "errorAlertNameColor-title".localizedText
                            errorMessage = "errorAlertNameColor-message3".localizedText
                            errorAlert = true
                            return
                        }
                        if nameBgColor.components.opacity < 0.2 {
                            errorTitle = "errorAlertNameColor-title".localizedText
                            errorMessage = "errorAlertNameColor-message4".localizedText
                            errorAlert = true
                            return
                        }
                        
                        
                        isLoading = true
                        func updateProfile() {
                            var uploadProfileUrl = inputImageURL != nil ? profileUrl : nil
                            if isDeletePhoto {
                                uploadProfileUrl = ""
                            }
                            ProfileModel.update(uid: uid,
                                                email: textEmail,
                                                name: textName,
                                                nickname: textNickName,
                                                profileImageURL: nil,
                                                uploadedProfileImageURL: uploadProfileUrl,
                                                nameColor: nameColor,
                                                nameBgColor: nameBgColor,
                                                introduce: textIntroduce
                                                ) { error in
                                if error == nil {
                                    presentation.wrappedValue.dismiss()
                                }
                                isLoading = false
                            }
                        }
                        
                        if let url = URL(string: profileUrl) {
                            if url.isFileURL {
                                FirebaseStorageManager.shared.uploadImage(fileUrl: url, uploadSize: CGSize(width: 300, height: 300), uploadPath: "profile/\(ProfileModel.current!.uid).jpg") { url in
                                    if let url = url?.absoluteString {
                                        self.profileUrl = url
                                        updateProfile()
                                    }
                                    else {
                                        errorTitle = "photoUploadError_title".localizedText
                                        errorMessage = "photoUploadError_message".localizedText
                                        errorAlert = true
                                        isLoading = false
                                    }
                                }
                                return
                            }
                        }
                        updateProfile()
                    }, label: {
                        "save".localizedText
                    })
            )
            .onAppear(perform: {
                
                LocationManager.shared.start()

                UITextField.appearance().clearButtonMode = .whileEditing
                guard let profile = ProfileModel.current else {
                    return
                }
                func loadData() {
                    displayName = profile.nameValue
                    textName = profile.name
                    textNickName = profile.nickname
                    textEmail = profile.email
                    profileUrl = profile.profileURL?.absoluteString ?? ""
                    textLastSigninDate = profile.lastSigninDate.formatedString(format: "yyyy년 M월 d일 H시 m분 s초")!
                    nameColor = profile.nameColor
                    nameBgColor = profile.nameBgColor
                    textIntroduce = profile.introduce
                }
                profile.getDataFromFireStore {
                    loadData()
                }
                loadData()
                
                Observable.collection(from: try! Realm().objects(LocationModel.self)).subscribe { event in
                    switch event {
                    case .next(let locations):
                        if let location = locations.last {
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
            ActivityIndicator($isLoading).frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .navigationBarTitle("profile-title".localized, displayMode: .large)

    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileEditView()
            ProfileEditView()
                .previewDevice("iPad Air (4th generation)")
        }
        .preferredColorScheme(.dark)
    }
}
