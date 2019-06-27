//
//  GitHubDemoUITests.swift
//  GitHubDemoUITests
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import XCTest

class GitHubDemoUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOpenDetailView() {
       
        let appUI = XCUIApplication()
        appUI.screenshot()
        
        if appUI.otherElements["LoginScreen"].exists {
            
            // LOGIN WITH USERNAME = "quenv", PASSWORD = "123456"
            let userNameTextField = appUI.textFields["username"]
            userNameTextField.tap()
            userNameTextField.typeText("quenv")
            
            let passwordTextField = appUI.secureTextFields["password"]
            passwordTextField.tap()
            passwordTextField.typeText("123456")
            
            let loginButton = appUI.buttons["Login"]
            
            // WAIT LOGIN BUTTON ENABLE AFTER VALIDATED
            let enablePredicate = NSPredicate(format: "isEnabled == true")
            expectation(for: enablePredicate, evaluatedWith: loginButton, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            // CLICK LOGIN
            loginButton.tap()
            appUI.screenshot()
        }
        
        // INPUT SEARCH TEXT
        let searchTextField = appUI.textFields["Search"]
        searchTextField.tap()
        searchTextField.typeText("quenv")
        
        // CHECK RESULT ON LABEL
        let cellLabel = appUI.staticTexts["raratiru/django-quenv"]
        let existPredicate = NSPredicate(format: "exists == true")
        expectation(for: existPredicate, evaluatedWith: cellLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // OPEN DETAIL SCREEN FROM FIRST CELL OF TABLEVIEW
        appUI.screenshot()
        let searchTableView = appUI.tables.element(boundBy: 0)
        let firstCell = searchTableView.cells.element(boundBy: 0)
        firstCell.tap()
        
        // CHECK DETAIL SCREEN DIDAPPEAR
        appUI.screenshot()
        let isExistDetailView = appUI.otherElements["DetailScreen"].exists
        
        XCTAssertTrue(isExistDetailView)
    }
}
