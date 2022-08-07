//
//  SelectTwo.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/23.
//

import SwiftUI

struct SelectDepartment: View {
    
    @EnvironmentObject var data : DataService
    @Binding var isPresenting: Bool
    @Binding var selectedCollege: String
    @State private var selectedDepartment = "화공생명환경공학부 환경공학전공"
    var departmentArr = DataDemo().departmentList
    
    // MARK: - 소속 학과 선택 화면
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            // 타이틀
            Text("소속 학과를 선택하세요")
                .font(.title)
                .bold()
                .padding()
            
            // 소속 학과 선택
            Menu {
                Picker(selection: $selectedDepartment) { ForEach(departmentArr[selectedCollege]!, id: \.self) { Text($0) }
                } label: {}
            } label: { Text("📚\(selectedDepartment)").selectedTextStyle() }.padding(.vertical, 50)
            
            // 완료 버튼
            Button {
                isPresenting = false
                data.currentDepartment = selectedDepartment
            } label: { Text("완료").buttonStyle(width: 300, ColorName: "MainColor") }
        }
        // 소속 학과 초기값 설정 (처음 표시되는 텍스트)
        .onAppear{
            selectedDepartment = departmentArr[selectedCollege]![0]
        }
    }
}
