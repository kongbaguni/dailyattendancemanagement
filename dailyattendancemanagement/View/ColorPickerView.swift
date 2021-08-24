//
//  ColorPickerView.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/24.
//

import SwiftUI

struct ColorPickerView: View {
    @State var color:Color = .white
    var body: some View {
        VStack {
            ColorPicker("select color", selection: $color)
        }
        .frame(width: .infinity, height: .infinity, alignment: .center)
        .background(color)
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}
