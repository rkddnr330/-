//
//  MoneyView.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/22.
//


import SwiftUI

struct MoneyView: View {
    
    @EnvironmentObject var data: DataService
    @Binding var isOnboardingActive : Bool
    @State private var searchText = ""
    @State private var isPresenting = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                // MARK: - 장학금 리스트 뷰
                
                List{
                    // 소속 학과 섹션
                    Section { ForEach(searchResults) { MoneyListCell(article: $0) }
                    } header: { Text(data.currentDepartment).foregroundColor(Color("SubColor"))
                    } footer: { Text("\(searchResults.count)개의 소식").bold() }
                    
                    // 학교 공홈 섹션
                    Section { ForEach(searchOfficialResults) { MoneyListCell(article: $0) }
                    } header: { Text("PNU 공지사항").foregroundColor(Color("SubColor"))
                    } footer: { Text("\(searchOfficialResults.count)개의 소식").bold() }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .refreshable { data.fetchPosts(department: data.currentDepartment) }
                .disableAutocorrection(true)
                .navigationTitle(Text("장학금 목록"))
                
                // MARK: - 하단 버튼
                
                HStack {
                    Button { isOnboardingActive = true
                    } label: { Text("튜토리얼").buttonStyle(width: 150, ColorName: "LogoSub") }
                    .padding()
                    
                    Button { isPresenting = true
                    } label: { Text("학과 선택").buttonStyle(width: 150, ColorName: "MainColor") }
                }
            }
            
            // 학과 선택 모달
            .sheet(isPresented: $isPresenting) {
                /// 기존 : VStack으로 SeleceCollege 묶음 : 왜?
                SelectCollege(isPresenting: $isPresenting)
            }
        }
    }
    
    // MARK: - 소속 학과 섹션의 검색 결과
    
    private var searchResults : [Post] {
        if searchText.isEmpty{
            return data.departmentPosts
        } else {
            return data.departmentPosts.filter({
                $0.title.lowercased().localizedStandardContains(searchText.lowercased())
            })
        }
    }
    
    // MARK: - 학교 공홈 섹션의 검색 결과
    
    private var searchOfficialResults : [Post] {
        if searchText.isEmpty{
            return data.centralPosts
        } else {
            return data.centralPosts.filter({
                $0.title.lowercased().localizedStandardContains(searchText.lowercased())
            })
        }
    }
}
