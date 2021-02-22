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
    private var mockUserValidator : UserFormValidatorDelegate!
    
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
        viewModel.processUpdateUser(userFormModel: userFormModel, endpoint: .updateUser)
        XCTAssertTrue(mockViewDelegate.successResponse)
    }

    //En este test quiero validar que se obtenga un error ya que el Name es muy corto.
    func testUserFormViewModel_CallProcessUpdateUser_ShouldFailTheTest(){
        let userFormModel1 = UserFormModel(name: "Vi", email: "test@test.com", phone: "1234567890")
        viewModel.processUpdateUser(userFormModel: userFormModel1, endpoint: .updateUser)
        XCTAssertTrue(mockViewDelegate.failValidations, "Falló porque alguna de la data que enviaste no es correcta.")
        
    }
    
    //En este test pongo a prueba cada validación de los campos.
    func testUserFormViewModel_TryEachValidation_ShouldPassTheTest(){
        //Debería pasar porque el nombre es correcto
        XCTAssertTrue(mockUserValidator.isNameValid(name: "John Doe"), "La validación isNameValida falló porque el Name no cumple con el requerimiento: Max \(userNameMaxLength), Min \(userNameMinLength)")
        
        //Debería pasar porque el email es correcto
        XCTAssertTrue(mockUserValidator.isEmailValid(email: "test@test.com"), "La validación isEmailValid falló porque el email que ingresó no es válido.")
        
        //Debería pasar porque el phone es correcto
        XCTAssertTrue(mockUserValidator.isPhoneValid(phone: "1234567890"), "La validación isPhoneValid falló porque el Phone no cumple con el requerimiento: Max/Min \(userPhoneMaxLength) digitos.")
    }
    
    func testUserFormViewModel_TryEachValidation_ShouldFailTheTest(){
        //Debería fallar porque el Name es incorrecto.
        XCTAssertFalse(mockUserValidator.isNameValid(name: "V"), "Esta validación debió fallar, aségurate de no cumplir con los requerimeintos: Max \(userNameMaxLength), Min \(userNameMinLength)")
        
        //Debería fallar porque el email es incorrecto.
        XCTAssertFalse(mockUserValidator.isEmailValid(email: "testtest.com"), "Esta validación debió fallar, aségurate de que el Email ingresado no sea válido.")
        
        //Debería fallar porque el teléfono es incorrecto
        XCTAssertFalse(mockUserValidator.isPhoneValid(phone: "1234567"), "Esta validación debió fallar, aségurate de no cumplir con los requerimeintos: Max/Min \(userPhoneMaxLength) digitos.")
    }
    
    
    func testUserFormViewModel_FailEachValidation(){
        mockViewDelegate = MockUserFormView()
        mockUserValidator = UserFormValidator()
        viewModel = UserFormViewModel(apiManager: MockApiManager(), viewDelegate: mockViewDelegate, formModelValidator: mockUserValidator)
        
        let userFormModel1 = UserFormModel(name: "J", email: "test@test.com", phone: "1234567890")
        viewModel.processUpdateUser(userFormModel: userFormModel1, endpoint: .updateUser)
        XCTAssertTrue(mockViewDelegate.failValidations, "Como el nombre no cumple con el min length, failValidations debería retornar true pero está obteniendo un false. Ya que SI cumple la condición Max \(userNameMaxLength), Min \(userNameMinLength)")
        
        mockViewDelegate = MockUserFormView()
        mockUserValidator = UserFormValidator()
        viewModel = UserFormViewModel(apiManager: MockApiManager(), viewDelegate: mockViewDelegate, formModelValidator: mockUserValidator)
        let userFormModel2 = UserFormModel(name: "John Doe", email: "testtest.com", phone: "1234567890")
        viewModel.processUpdateUser(userFormModel: userFormModel2, endpoint: .updateUser)
        XCTAssertTrue(mockViewDelegate.failValidations, "Como el email no es válido, failValidations debería retornar true pero está obteniendo un false. Ya que no cumple la condición de que sea un Email válido")
        
        mockViewDelegate = MockUserFormView()
        mockUserValidator = UserFormValidator()
        viewModel = UserFormViewModel(apiManager: MockApiManager(), viewDelegate: mockViewDelegate, formModelValidator: mockUserValidator)
        let userFormModel3 = UserFormModel(name: "John Doe", email: "test@test.com", phone: "1234567")
        viewModel.processUpdateUser(userFormModel: userFormModel3, endpoint: .updateUser)
        XCTAssertTrue(mockViewDelegate.failValidations, "Como el phone no es válido, failValidations debería retornar true pero está obteniendo un false. Ya que SI cumple la condicion: Max/Min \(userPhoneMaxLength) digitos.")
    }
}
