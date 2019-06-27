//
//  SearchRepositorySeviceTests.swift
//  GitHubDemoTests
//
//  Created by Macbook on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import XCTest
import RxSwift
@testable import GitHubDemo

class SearchRepositorySeviceTests: XCTestCase {

    private let disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSearchUsers() {
        let expectation = XCTestExpectation(description: "Search Repository")
        SearchRepositoryServiceMock().searchRepositories(query: "quenv")
            .subscribe(onNext: { (repositories, status) in
            if status == .success {
                XCTAssertNotNil(repositories)
                expectation.fulfill()
            } else {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }

}
