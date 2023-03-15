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

    // MARK: - fetchPosts 함수
    
    func fetchPosts(department: String) {
        
        // fetch 전, 리스트 비우기
        departmentPosts.removeAll()
        centralPosts.removeAll()
        
        // MARK: - 소속 학과 데이터

        let departmentUrlString = DataDemo.originURL["\(department)"]!
        let departmentScholarshipUrlString = DataDemo.originURL["\(department)"]! + DataDemo.detailURL["\(department)"]!
        let departmentUrl = URL(string: departmentUrlString)

        getElements(from: departmentScholarshipUrlString, className: "_artclTdTitle") { elements in
            DispatchQueue.main.async {
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
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let centralUrl = URL(string: "https://www.pusan.ac.kr/kor/CMS/Board/Board.do")
        
        getElements(from: centralScholarshipUrlString, className: "stitle") { elements in
            DispatchQueue.main.async {
                guard let centralUrl = centralUrl, let elements = elements else { return }
                self.generatePosts(
                    of: .central,
                    from: elements,
                    baseUrl: centralUrl)
            }
        }
    }
    
    // MARK: - fetchPosts에 쓰이는 함수들

    var urlSession: URLSessionProtocol = URLSession.shared
    
    // TODO: 1.Alamofire 사용, 2.의존성 주입(O), 3.에러 핸들링
    private func getElements(from urlString: String, className: String, completionHandler: @escaping ((Elements?) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            do {
                let htmlContents = String(data: data, encoding: .utf8)
                let document = try SwiftSoup.parse(htmlContents ?? "")
                let elements = try document.getElementsByClass(className)
                completionHandler(elements)
            } catch {
                completionHandler(nil)
            }
        }
        dataTask.resume()
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
