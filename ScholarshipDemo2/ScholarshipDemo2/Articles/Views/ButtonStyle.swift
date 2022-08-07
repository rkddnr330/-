//
//  ButtonStyle.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/08/03.
//

import SwiftUI

// MARK: - 버튼 스타일 정의 (Text가 버튼처럼 보이게)
extension Text {
    func buttonStyle(width: Double, ColorName: String) -> some View {
        self.font(.title3)
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(width: width)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(ColorName)))
    }
    
    func selectedTextStyle() -> some View {
        self.font(.title2)
            .bold()
            .foregroundColor(Color("Button"))
    }
}
