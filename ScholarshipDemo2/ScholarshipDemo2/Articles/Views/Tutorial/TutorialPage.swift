//
//  TutorialPage.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/08/03.
//

import SwiftUI

// MARK: - 튜토리얼 첫번째 페이지 뷰 형식

struct TutorialPage: View {
    
    var pageNum : Int
    var imageName, titleText, middleText1, middleText2 : String?

    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Image(imageName ?? "")
            Text(titleText ?? "")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding()
            
            HStack{
                Image("midalChat")
                Text(middleText1 ?? "")
                    .foregroundColor(.white)
            }
            
            Text(middleText2 ?? "").foregroundColor(.white)
        }
        .tag(pageNum - 1)
    }
}

// MARK: - 튜토리얼 스크린샷 포함된 페이지 뷰 형식

struct TutorialScreenshotPage: View {
    
    var pageNum: Int
    var imageName, titleText, middleText1, middleText2: String?
    @Binding var isOnboardingActive: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Image(imageName ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15.0)
                .frame(width: (UIScreen.main.bounds.width) * 0.7)
            
            Text(titleText ?? "")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .padding()
            
            HStack{
                Image("midalChat")
                Text(middleText1 ?? "")
                    .foregroundColor(.white)
            }
            
            Text(middleText2 ?? "").foregroundColor(.white)
            
            if pageNum == 6 {
                Button { isOnboardingActive = false
                } label: { Text("시작하기").buttonStyle(width: 300, ColorName: "MainColor") }
                .padding(.top, 20)
            }
        }
        .tag(pageNum - 1)
    }
}
