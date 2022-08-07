//
//  AppStorageTest.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/23.
//

import SwiftUI

struct AppStorageTest: View {
    @AppStorage("text") var isOnboardingActive = true
    
    @State var isLoading: Bool = true
    var body: some View {
        ZStack {
            // 앱 화면
            if isOnboardingActive {
                TutorialView(isOnboardingActive: $isOnboardingActive).zIndex(0)
            } else {
                MoneyView(isOnboardingActive: $isOnboardingActive).zIndex(0)
            }
            
            // Launch Screen
            if isLoading {
                launchScreenView.transition(.opacity).zIndex(1)
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                withAnimation { isLoading.toggle() }
            })
        }
    }
}

extension AppStorageTest {
    var launchScreenView: some View {
        ZStack(alignment: .center) {
            LinearGradient(gradient: Gradient(colors: [Color("LogoMain"), Color("LogoSub")]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            Image("splash2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (UIScreen.main.bounds.width) * 0.6)
        }
    }
}
