//
//  SelectOne.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/23.
//

import SwiftUI

struct SelectCollege: View {
    
    @EnvironmentObject var data : DataService
    @Binding var isPresenting: Bool
    @State var selectedCollege = "공과대학"
    var collegeArr = DataDemo.collegeList
    
    // MARK: - 소속 대학 선택 화면
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 20) {
                
                // 타이틀
                Text("소속 단과 대학을 선택하세요")
                    .font(.title)
                    .bold()
                    .padding()
                
                // 단과대학 선택
                Menu {
                    Picker(selection: $selectedCollege) { ForEach(collegeArr, id: \.self) { Text($0) }
                    } label: {}
                } label: { Text("🏫\(selectedCollege)").selectedTextStyle() }.padding(.vertical, 50)
                
                // 다음 버튼
                NavigationLink {
                    SelectDepartment(isPresenting: $isPresenting, selectedCollege: $selectedCollege)
                } label: { Text("다음").buttonStyle(width: 300, ColorName: "MainColor") }
            }
        }
    }
}

