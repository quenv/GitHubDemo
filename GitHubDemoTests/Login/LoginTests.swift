//
//  LoginViewModelTests.swift
//  GitHubDemoTests
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import XCTest
@testable import GitHubDemo

class LoginTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHas6Digit() {

        XCTAssertTrue(("123456").has6Digit())
        XCTAssertTrue(("777775").has6Digit())
        XCTAssertTrue(("911111").has6Digit())

        XCTAssertFalse(("123").has6Digit())
        XCTAssertFalse(("12345").has6Digit())
        XCTAssertFalse(("1234567").has6Digit())
        XCTAssertFalse(("123456789").has6Digit())
    }

    func testHasAllSameDigit() {

        XCTAssertTrue(("11111").hasAllSameDigit())
        XCTAssertTrue(("222222").hasAllSameDigit())

        XCTAssertFalse(("11112").hasAllSameDigit())
        XCTAssertFalse(("21111").hasAllSameDigit())
        XCTAssertFalse(("123456").hasAllSameDigit())
        XCTAssertFalse(("777775").hasAllSameDigit())
        XCTAssertFalse(("911111").hasAllSameDigit())

    }
    
    func testValidatePassword() {
        
        XCTAssertTrue(("123456").isValidPassword())
        XCTAssertTrue(("777775").isValidPassword())
        XCTAssertTrue(("911111").isValidPassword())
       
        XCTAssertFalse(("222222").isValidPassword())
        XCTAssertFalse(("12345a").isValidPassword())
        XCTAssertFalse(("12345").isValidPassword())
        XCTAssertFalse(("1234567").isValidPassword())
    }

    
}
