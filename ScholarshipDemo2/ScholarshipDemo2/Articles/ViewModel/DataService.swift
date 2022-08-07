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

        let articleURL = makeURL(department: department).0
        let baseURL = makeURL(department: department).1
        
        if let articleURL = articleURL {
            let allPosts = getAllPosts(from: articleURL)
            guard let baseURL = baseURL else { return }
            
            generatePostList(from: allPosts, baseURL: baseURL)
        }
        
        // MARK: - 공홈 데이터
        
        let officialURL = "https://www.pusan.ac.kr/kor/CMS/Board/Board.do"
        let baseOfficialURL = URL(string:officialURL)
        let offString = "https://www.pusan.ac.kr/kor/CMS/Board/Board.do?robot=Y&mCode=MN095&searchID=title&searchKeyword=장학&mgr_seq=3&mode=list&page=1"

        guard let encodedOfficial = offString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let offURL = URL(string: encodedOfficial)
        
        if let offURL = offURL{
            do {
                let websiteString = try String(contentsOf: offURL)
                
                let document = try SwiftSoup.parse(websiteString)
                
                
                //                let articles = try document.getElementsByClass("item-list").select("article")
                ///artclTdTitle 이라는 클래스를 가진 코드 불러오기
                let articles = try document.getElementsByClass("stitle")
                
                for article in articles{
                    let title = try article.select("a").first()?.text(trimAndNormaliseWhitespace: true) ?? ""
                    
                    guard let baseOfficialURL = baseOfficialURL else {
                        return
                    }
                    
                    let url = try baseOfficialURL.appendingPathComponent(article.select("a").attr("href"))

                    let changedUrl = URL(string: url.description.replacingOccurrences(of: "/%3F", with: "?"))
                    
                    let post = Article(title: title, url: changedUrl)
                    if post.title.contains("장학") {
                        self.officialList.append(post)
                    }
                }
            }
            
            catch let error {
                print(error)
            }
        }
    }
}

// MARK: - fetchArticles에 쓰이는 함수들

extension DataService {
    
    private func makeURL(department: String) -> (URL?, URL?) {
        var selectedBaseURL: String = DataDemo().originURL["\(department)"]!
        let selectedDetailURL: String = DataDemo().detailURL["\(department)"]!
        
        let baseURL = URL(string:selectedBaseURL)
        
        selectedBaseURL.append("\(selectedDetailURL)")
        let articleURL = URL(string:selectedBaseURL)

        return (articleURL, baseURL)
    }
    
    private func getAllPosts(from articleURL: URL) -> Elements {
        do {
            let websiteString = try String(contentsOf: articleURL)
            let document = try SwiftSoup.parse(websiteString)
            let articles = try document.getElementsByClass("_artclTdTitle")
            return articles
        } catch { return SwiftSoup.Elements.init() }
    }
    
    private func generatePostList(from allPosts: Elements, baseURL: URL) {
        do {
            for eachPost in allPosts {
                let title = try eachPost.select("a").first()?.text(trimAndNormaliseWhitespace: true) ?? ""
                let url = try baseURL.appendingPathComponent(eachPost.select("a").attr("href"))
                let scholarshipPost = Article(title: title, url: url)
                if scholarshipPost.title.contains("장학") { self.postList.append(scholarshipPost) }
            }
        } catch { print("generate error") }
    }
}
