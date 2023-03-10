//
//  Article.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/07.
//

import Foundation

struct Post: Identifiable, Hashable{
    let id = UUID().uuidString
    var title: String
    var url : URL?
    
    init(_ title: String, _ url: URL? = nil) {
        self.title = title
        self.url = url
    }
}
