//
//  Article.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/07.
//

import Foundation

struct Article: Identifiable, Hashable{
    let id = UUID().uuidString
    var title: String
    var url : URL?
}
