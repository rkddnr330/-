//
//  URLSessionProtocol.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2023/03/15.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
