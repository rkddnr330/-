//
//  DataService.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/07.
//

import Foundation
import SwiftSoup
import SwiftUI

class DataService: ObservableObject {

    @Published var postList = [Article]()
    @Published var officialList = [Article]()
    @AppStorage("department") var currentDepartment : String = "화공생명환경공학부 환경공학전공" {
        didSet { fetchPosts(department: currentDepartment) }
    }
    
    init() { fetchPosts(department: currentDepartment) }

    // MARK: - fetchArticles 함수
    
    func fetchPosts(department: String) {
        
        // fetch 전, 리스트 비우기
        postList.removeAll()
        officialList.removeAll()
        
        // MARK: - 소속 학과 데이터

        let articleURL = makeURL(of: department).0
        let baseURL = makeURL(of: department).1
        
        if let articleURL = articleURL {
            let allPosts = getAllPosts(from: articleURL, className: "_artclTdTitle")
            guard let baseURL = baseURL else { return }
            
            generatePostList(from: allPosts, baseURL: baseURL)
        }
        
        // MARK: - 공홈 데이터
        
        /// post의 URL에서 공통된 부분.
        /// 나중에 각 post의 뒷부분 URL을 가져와서 baseOfficialURL 뒤에 붙인다.
        let baseOfficialURL = URL(string: "https://www.pusan.ac.kr/kor/CMS/Board/Board.do")
        let officialURL = makeOfficialURL()
        
        if let officialURL = officialURL{
            let officialAllPosts = getAllPosts(from: officialURL, className: "stitle")
            guard let baseOfficialURL = baseOfficialURL else { return }

            generateOfficialList(from: officialAllPosts, baseURL: baseOfficialURL)
        }
    }
}

// MARK: - fetchArticles에 쓰이는 함수들

extension DataService {
    
    private func makeURL(of department: String) -> (URL?, URL?) {
        var selectedBaseURL: String = DataDemo().originURL["\(department)"]!
        let selectedDetailURL: String = DataDemo().detailURL["\(department)"]!
        
        let baseURL = URL(string:selectedBaseURL)
        
        selectedBaseURL.append("\(selectedDetailURL)")
        let articleURL = URL(string:selectedBaseURL)

        return (articleURL, baseURL)
    }
    
    private func getAllPosts(from articleURL: URL, className: String) -> Elements {
        do {
            let websiteString = try String(contentsOf: articleURL)
            let document = try SwiftSoup.parse(websiteString)
            let articles = try document.getElementsByClass(className)
            return articles
        } catch { return SwiftSoup.Elements.init() }
    }
    
    private func makeOfficialURL() -> URL? {
        let nonencodedURL = "https://www.pusan.ac.kr/kor/CMS/Board/Board.do?robot=Y&mCode=MN095&searchID=title&searchKeyword=장학&mgr_seq=3&mode=list&page=1"
        let encodedURL = nonencodedURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let officialURL = URL(string: encodedURL ?? "https://www.pusan.ac.kr/kor/CMS/Board/Board.do")
        
        return officialURL
    }
    
    private func generatePostList(from allPosts: Elements, baseURL: URL) {
        do {
            for eachPost in allPosts {
                let title = try eachPost.select("a").first()?.text(trimAndNormaliseWhitespace: true) ?? ""
                let url = try baseURL.appendingPathComponent(eachPost.select("a").attr("href"))
                let scholarshipPost = Article(title: title, url: url)
                if scholarshipPost.title.contains("장학") { self.postList.append(scholarshipPost) }
            }
        } catch { print("postList generation error") }
    }
    
    private func generateOfficialList(from allPosts: Elements, baseURL: URL) {
        do {
            for eachPost in allPosts{
                let title = try eachPost.select("a").first()?.text(trimAndNormaliseWhitespace: true) ?? ""
                let url = try baseURL.appendingPathComponent(eachPost.select("a").attr("href"))
                let changedUrl = URL(string: url.description.replacingOccurrences(of: "/%3F", with: "?"))
                let scholarshipPost = Article(title: title, url: changedUrl)
                if scholarshipPost.title.contains("장학") { self.officialList.append(scholarshipPost) }
            }
        } catch { print("officialList generation error")}
    }
}
