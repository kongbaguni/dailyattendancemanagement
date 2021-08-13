//
//  ReadyView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/06.
//

import SwiftUI

struct ReadyView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 10)
            LottieView(filename: "lottie/work")
                .frame(
                    minWidth: 100,
                    maxWidth: .infinity,
                    minHeight: 200,
                    maxHeight: 300,
                    alignment: .center
                )
                .shadow(radius: 20)
            Spacer(minLength: 10)
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

struct ReadyView_Previews: PreviewProvider {
    static var previews: some View {
        ReadyView()
            .previewDevice("iPad Air (4th generation)")
    }
}
