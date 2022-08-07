//
//  TutorialView.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/23.
//

import SwiftUI

struct TutorialView: View {
    @State private var selectedTab = 0
    @Binding var isOnboardingActive: Bool
    
    var body: some View {
        ZStack {
            
            // MARK: - 뒷배경 색 그라데이션
            
            LinearGradient(
                gradient: Gradient(colors: [Color("LogoMain"), Color("LogoSub")]),
                startPoint: .top,
                endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.7)
            
            // MARK: - 튜토리얼
            
            GeometryReader( content: { geometry in
                VStack {
                    TabView(selection: $selectedTab){   ///Carousel : TabView의 Style 중 하나
                        
                        // MARK: - 1페이지
                        
                        TutorialPage(
                            pageNum: 1,
                            imageName: "midal",
                            titleText: "미달이를 소개할게요",
                            middleText1: ":  안녕하세요 제 이름은 미달이에요",
                            middleText2: "저는 여러분들의 장학금 소식을 물어다 줄 거에요")
                        .frame(maxHeight:geometry.size.height * 0.6)
                        
                        // MARK: - 2페이지
                        
                        TutorialScreenshotPage(
                            pageNum: 2,
                            imageName: "0",
                            titleText: "'학과 선택' 버튼 누르기",
                            middleText1: ":  먼저 하단의 학과 선택 버튼을 눌러주세요",
                            isOnboardingActive: $isOnboardingActive)
                        .frame(maxHeight:geometry.size.height * 0.6)
                        
                        // MARK: - 3페이지
                        
                        TutorialScreenshotPage(
                            pageNum: 3,
                            imageName: "1",
                            titleText: "단과 대학 선택하기",
                            middleText1: ":  여러분들의 소속 대학을 선택해주세요",
                            isOnboardingActive: $isOnboardingActive)
                        .frame(maxHeight:geometry.size.height * 0.6)
                        
                        // MARK: - 4페이지
                        
                        TutorialScreenshotPage(
                            pageNum: 4,
                            imageName: "2",
                            titleText: "소속 학과 선택하기",
                            middleText1: ":  마지막으로 소속 학과를 선택하고",
                            middleText2: "완료 버튼을 눌러주세요",
                            isOnboardingActive: $isOnboardingActive)
                        .frame(maxHeight:geometry.size.height * 0.6)
                        
                        // MARK: - 5페이지
                        
                        TutorialScreenshotPage(
                            pageNum: 5,
                            imageName: "3",
                            titleText: "장학금 소식 확인하기",
                            middleText1: ":  그럼 제가 장학금 소식을 물어다 줄 거에요",
                            isOnboardingActive: $isOnboardingActive)
                        .frame(maxHeight:geometry.size.height * 0.6)
                        
                        // MARK: - 6페이지
                        
                        TutorialScreenshotPage(
                            pageNum: 6,
                            imageName: "4",
                            titleText: "PNU 공지사항",
                            middleText1: ":  PNU 공지사항으로",
                            middleText2: "부산대 전체 공지사항도 챙겨드려요",
                            isOnboardingActive: $isOnboardingActive)
                        .frame(maxHeight:geometry.size.height * 0.7)
                    }
                    
                    .frame(
                        maxHeight: geometry.size.height * 0.9,
                        alignment: .center)
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear{ setupAppearance() }
                }
            }
            )
        }
    }
    
    // MARK: - Indicator 색 설정
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("MainColor"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("CarouselSub"))
    }
}
