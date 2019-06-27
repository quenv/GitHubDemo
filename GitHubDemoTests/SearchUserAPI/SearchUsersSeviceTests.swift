//
//  SearchUsersSeviceTests.swift
//  GitHubDemoTests
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import XCTest
import RxSwift
@testable import GitHubDemo

class SearchUsersSeviceTests: XCTestCase {

    private let disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSearchUsers() {
        let expectation = XCTestExpectation(description: "Search Users")
        SearchUsersServiceMock().searchUsers(query: "quenvSmartOSC")
            .subscribe(onNext: { (usernames, status) in
            if status == .success {
                XCTAssertNotNil(usernames)
                expectation.fulfill()
            } else {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)
                
        wait(for: [expectation], timeout: 5.0)
    }

}
