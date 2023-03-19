//
//  ScholarshipDemo2SlowTest.swift
//  ScholarshipDemo2UnitTests
//
//  Created by Park Kangwook on 2023/03/10.
//

import XCTest

final class ScholarshipDemo2SlowTest: XCTestCase {
    var sut: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // response의 statusCode가 200인지
    func testURLSession_HTTPResponse의_StatusCode가_200인지() throws {
        let urlString = "https://www.pusan.ac.kr/kor/Main.do"
        let url = URL(string: urlString)!
        var statusCode: Int?
        var urlError: Error?
        let promise = expectation(description: "http response : 200")
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            urlError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(urlError)
        XCTAssertEqual(statusCode, 200)
    }
}
