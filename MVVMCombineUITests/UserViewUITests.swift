//
//  MVVMCombineUITests.swift
//  MVVMCombineUITests
//
//  Created by Victor Roldan on 10/02/21.
//

import XCTest

class UserViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUserView_TableView() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tableView = XCUIApplication().tables["tableViewUsers"]
        tableView.swipeUp()
        tableView.cells.containing(.cell, identifier:"userNameLabel_5").element.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        tableView.swipeUp()
        tableView.swipeDown()
        tableView.cells["userNameLabel_5"].buttons["tapMe"].tap()

    }


}
