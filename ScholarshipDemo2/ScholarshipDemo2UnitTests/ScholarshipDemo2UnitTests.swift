//
//  ScholarshipDemo2UnitTests.swift
//  ScholarshipDemo2UnitTests
//
//  Created by Park Kangwook on 2023/03/09.
//

import XCTest
@testable import ScholarshipDemo2

final class ScholarshipDemo2UnitTests: XCTestCase {
    var sut: DataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataService()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testPostList와_OfficialList가_잘_생성되는지() throws {
        // given
        let department = "화공생명환경공학부 환경공학전공"
        
        // when
        sut.fetchPosts(department: department)
        
        // then
        XCTAssertGreaterThan(sut.departmentPosts.count, 0, "postList가 비었습니다.")
        XCTAssertGreaterThan(sut.centralPosts.count, 0, "officialList가 비었습니다.")
    }
    
    // sut :
    // response의 statusCode가 200인지
    func testURLSession_잘되는지() throws {
        
    }
    
    // sut :
    // HTML parsing 테스트
    func testElements에서_데이터_잘불러오는지() throws {
        
    }
    
    // sut : DataService
    func test학과_변경_잘되는지() throws {
        
    }
    
    // sut : DataService
    func test변경된_데이터가_Posts에_추가되는지() throws {
        // given
        
    }
}
