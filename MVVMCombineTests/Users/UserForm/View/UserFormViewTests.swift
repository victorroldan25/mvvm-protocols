//
//  UserFormViewTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 11/02/21.
//

@testable import MVVMCombine
import XCTest

class UserFormViewTests: XCTestCase {
    private var viewModel         : UserFormViewModel!
    private var mockViewDelegate  : MockUserFormView!
    private var mockUserValidator : UserFormValidator!
    
    override func setUpWithError() throws {
        mockViewDelegate = MockUserFormView()
        mockUserValidator = UserFormValidator()
        viewModel = UserFormViewModel(apiManager: MockApiManager(), viewDelegate: mockViewDelegate, formModelValidator: mockUserValidator)
    }

    override func tearDownWithError() throws {
        viewModel         = nil
        mockViewDelegate  = nil
        mockUserValidator = nil
    }
    
    func testUserFormViewModel_CallProcessUpdateUser_ShouldPassTheTest(){
        //Should get a success response due to provided data is correct
        let userFormModel = UserFormModel(name: "Victor", email: "test@test.com", phone: "1234567890")
        viewModel.processUpdateUser(userFormModel: userFormModel)
        XCTAssertTrue(mockViewDelegate.successResponse)
    }

    func testUserFormViewModel_CallProcessUpdateUser_ShouldFailTheTest(){
        //Should fail because the provided data is incorrect. The name is too short
        let userFormModel1 = UserFormModel(name: "Vi", email: "test@test.com", phone: "12345678910")
        viewModel.processUpdateUser(userFormModel: userFormModel1)
        XCTAssertTrue(mockViewDelegate.failValidations)
        
    }
    
    func testUserFormViewModel_TryEachValidation_ShouldPassTheTest(){
        //Should pass because the email is incorrect
        XCTAssertTrue(mockUserValidator.isEmailValid(email: "test@test.com"))
        
        //Should pass because the name is incorrect
        XCTAssertTrue(mockUserValidator.isNameValid(name: "Victor"))
        
        //Should pass because the phone is incorrect
        XCTAssertTrue(mockUserValidator.isPhoneValid(phone: "1234567890"))
    }
    
    func testUserFormViewModel_TryEachValidation_ShouldFailTheTest(){
        //Should fail because the email is incorrect
        XCTAssertFalse(mockUserValidator.isEmailValid(email: "testtest.com"))
        
        //Should fail because the email is incorrect
        XCTAssertFalse(mockUserValidator.isNameValid(name: "V"))
        
        //Should fail because the phone is incorrect
        XCTAssertFalse(mockUserValidator.isPhoneValid(phone: "1234567"))
    }
}
