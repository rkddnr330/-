//
//  DataService.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/07.
//

import Foundation
import SwiftSoup
import SwiftUI

enum Category {
    case department, central
}

class DataService: ObservableObject {
    @Published var departmentPosts = [Post]()
    @Published var centralPosts = [Post]()
    @AppStorage("department") var currentDepartment : String = "화공생명환경공학부 환경공학전공" {
        didSet { fetchPosts(department: currentDepartment) }
    }
    
    init() { fetchPosts(department: currentDepartment) }

    // MARK: - fetchArticles 함수
    
    func fetchPosts(department: String) {
        
        // fetch 전, 리스트 비우기
        departmentPosts.removeAll()
        centralPosts.removeAll()
        
        // MARK: - 소속 학과 데이터

        let departmentUrlString = DataDemo.originURL["\(department)"]!
        let departmentScholarshipUrlString = DataDemo.originURL["\(department)"]! + DataDemo.detailURL["\(department)"]!
        
        let departmentUrl = URL(string: departmentUrlString)
        let departmentScholarshipUrl = URL(string: departmentScholarshipUrlString)
        
        if let departmentScholarshipUrl = departmentScholarshipUrl {
            getElements(from: departmentScholarshipUrl, className: "_artclTdTitle") { elements in
                guard let departmentUrl = departmentUrl, let elements = elements  else { return }
                self.generatePosts(
                    of: .department,
                    from: elements,
                    baseUrl: departmentUrl)
            }
        }
        
        // MARK: - 공홈 데이터
        
        /// post의 URL에서 공통된 부분.
        /// 나중에 각 post의 뒷부분 URL을 가져와서 baseOfficialURL 뒤에 붙인다.
        let centralScholarshipUrlString = DataDemo.centralScholarshipUrlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let centralScholarshipUrl = URL(string: centralScholarshipUrlString!)
        let centralUrl = URL(string: "https://www.pusan.ac.kr/kor/CMS/Board/Board.do")
        
        if let centralScholarshipUrl = centralScholarshipUrl {
            getElements(from: centralScholarshipUrl, className: "stitle") { elements in
                guard let centralUrl = centralUrl, let elements = elements else { return }
                self.generatePosts(
                    of: .central,
                    from: elements,
                    baseUrl: centralUrl)
            }
        }
    }
}

// MARK: - fetchArticles에 쓰이는 함수들

extension DataService {
    private func getElements(from departmentUrl: URL, className: String, completionHandler: @escaping ((Elements?) -> Void)) {
        do {
            let websiteString = try String(contentsOf: departmentUrl)
            let document = try SwiftSoup.parse(websiteString)
            let elements = try document.getElementsByClass(className)
            completionHandler(elements)
        } catch { completionHandler(SwiftSoup.Elements.init()) }
    }
    
    private func generatePosts(of category: Category, from elements: Elements, baseUrl: URL) {
        do {
            for element in elements {
                let title = try element
                    .select("a")
                    .first()?
                    .text(trimAndNormaliseWhitespace: true) ?? ""
                let url = try baseUrl.appendingPathComponent(element
                    .select("a")
                    .attr("href"))
                
                switch category {
                case .department:
                    let post = Post(title, url)
                    if post.title.contains("장학") {
                        self.departmentPosts.append(post)
                    }
                case .central:
                    let centralUrl = URL(string: url
                        .description
                        .replacingOccurrences(
                            of: "/%3F",
                            with: "?"))
                    let post = Post(title, centralUrl)
                    if post.title.contains("장학") {
                        self.centralPosts.append(post)
                    }
                }
            }
        } catch { print("postList generation error") }
    }
}
