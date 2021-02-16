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
        
        
        //Clean all UITextFields
        let nameTextField = app.textFields["nameTFIdentifier"]
        nameTextField.clearAndEnterText(text: "")
        
        let emailTextField = app.textFields["emailTFIdentifier"]
        emailTextField.clearAndEnterText(text: "")
        
        let phoneTextField = app.textFields["phoneTFIdentifier"]
        phoneTextField.clearAndEnterText(text: "")
        
        //Incorrect Name
        nameTextField.clearAndEnterText(text: "Vi")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()
        
        //Correct Name
        nameTextField.clearAndEnterText(text: "Victor")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()
        
        //Incorrect Email
        emailTextField.clearAndEnterText(text: "test@te")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()
        
        //Correct Name
        emailTextField.clearAndEnterText(text: "test@test.com")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()
        
        //Incorrect Phone
        phoneTextField.clearAndEnterText(text: "1234567")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()
        
        //Correct Name
        phoneTextField.clearAndEnterText(text: "1234567890")
        app.buttons["updateUserButton"].tap()
        app.alerts["customAlert"].scrollViews.otherElements.buttons["OK"].tap()

        //Go Back.
        app.navigationBars.buttons.element(boundBy: 0).tap()

    }


}

extension XCUIElement {

    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        let goRight = self.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
        goRight.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
