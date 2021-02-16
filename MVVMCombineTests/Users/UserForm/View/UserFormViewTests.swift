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
    
    //Debería obtener un success response ya que la data que se envió es correcta
    func testUserFormViewModel_CallProcessUpdateUser_ShouldPassTheTest(){
        let userFormModel = UserFormModel(name: "Victor", email: "test@test.com", phone: "1234567890")
        viewModel.processUpdateUser(userFormModel: userFormModel)
        XCTAssertTrue(mockViewDelegate.successResponse)
    }

    //En este test quiero validar que se obtenga un error ya que el Name es muy corto.
    func testUserFormViewModel_CallProcessUpdateUser_ShouldFailTheTest(){
        let userFormModel1 = UserFormModel(name: "Vi", email: "test@test.com", phone: "12345678910")
        viewModel.processUpdateUser(userFormModel: userFormModel1)
        XCTAssertTrue(mockViewDelegate.failValidations)
        
    }
    
    //En este test pongo a prueba cada validación de los campos.
    func testUserFormViewModel_TryEachValidation_ShouldPassTheTest(){
        //Debería pasar porque el nombre es correcto
        XCTAssertTrue(mockUserValidator.isNameValid(name: "John Doe"))
        
        //Debería pasar porque el email es correcto
        XCTAssertTrue(mockUserValidator.isEmailValid(email: "test@test.com"))
        
        //Debería pasar porque el phone es correcto
        XCTAssertTrue(mockUserValidator.isPhoneValid(phone: "1234567890"))
    }
    
    func testUserFormViewModel_TryEachValidation_ShouldFailTheTest(){
        //Debería fallar porque el Name es incorrecto.
        XCTAssertFalse(mockUserValidator.isNameValid(name: "V"))
        
        //Debería fallar porque el email es incorrecto.
        XCTAssertFalse(mockUserValidator.isEmailValid(email: "testtest.com"))
        
        //Debería fallar porque el teléfono es incorrecto
        XCTAssertFalse(mockUserValidator.isPhoneValid(phone: "1234567"))
    }
}
