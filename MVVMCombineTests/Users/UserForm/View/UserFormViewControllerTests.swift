//
//  UserFormViewControllerTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import XCTest

class UserFormViewControllerTests: XCTestCase {
    
    var storyboard      : UIStoryboard!
    var vc              : UserFormViewController!
    let userDataToPrint = UserDataToPrint(id: "1", name: "John Doe", email: "test@test.com", phone: "1234567890")
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: "userFormVC") as? UserFormViewController
        vc.userDataToPrint = userDataToPrint
        vc?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        vc = nil
        storyboard = nil
    }

    //En este test busco validar que cada TextField tenga su IBOutlet y que al cargar el ViewController, cada TextField tenga el valor correcto.
    func testUserFormViewController_ValidateEveryTextFiedHasAnIBOutlet_ShouldContainTheModelData() throws {
        
        //Valido que cada campo tenga su IBOutlet
        let name = try XCTUnwrap(vc.nameTextField, "La propiedad nameTextField no tiene un IBOutlet")
        let email = try XCTUnwrap(vc.emailTextField, "La propiedad emailTextField no tiene un IBOutlet")
        let phone = try XCTUnwrap(vc.phoneTextField, "La propiedad phoneTextField no tiene un IBOutlet")
        
        //Valido que cada campo tenga el valor correcto que se le pasó al instanciar el ViewController a través de userDataToPrint
        XCTAssertEqual(name.text!, userDataToPrint.name, "El TextField Name no tenía el valor correcto cuando se cargó el VC")
        XCTAssertEqual(email.text!, userDataToPrint.email, "El TextField Email no tenía el valor correcto cuando se cargó el VC")
        XCTAssertEqual(phone.text!, userDataToPrint.phone, "El TextField Phone no tenía el valor correcto cuando se cargó el VC")
    }
    
    //En este test busco validar que el Botón tenga su IBOutlet y que tenga un Action asociado.
    func testUserFormViewController_ValidateIfUpdateButtonHasAnActionAndIBOutlet() throws{
        
        //Valido que el botón updateUserButton tenga su IBOutlet
        let updateButton : UIButton = try XCTUnwrap(vc.updateUserButton, "El botón updateUserButton no tiene un IBOutlet")
        
        //Validar si el botón updateUserButton tiene una acción.
        let updateButtonActions = try XCTUnwrap(updateButton.actions(forTarget: vc, forControlEvent: .touchUpInside), "El botón updateUserButton no tiene ninguna acción asociada.")
        
        //Valido si el botón tiene una sola acción
        XCTAssertEqual(updateButtonActions.count, 1, "El botón Update User no tiene ninguna acción asignada.")
        
    }
    
    func testUserFormViewController_ValidateUITextFieldKeyboardType_ShouldHaveTheCorrectOnes(){
        XCTAssertEqual(vc.nameTextField.keyboardType, .default, "El keyboardType asignado a nameTextField no es el correcto, debería ser Defualt.")
        XCTAssertEqual(vc.emailTextField.keyboardType, .emailAddress, "El keyboardType asignado a emailTextField no es el correcto, debería ser EmailAddress.")
        XCTAssertEqual(vc.phoneTextField.keyboardType, .phonePad, "El keyboardType asignado a phoneTextField no es el correcto, debería ser PhonePad.")
    }

    func testUserFormViewController_ValidateUITextFieldContentType_ShouldHaveTheCorrectOnes(){
        XCTAssertEqual(vc.nameTextField.textContentType, .name, "El textContentType asignado a nameTextField no es el correcto, debería ser Defualt.")
        XCTAssertEqual(vc.emailTextField.textContentType, .emailAddress, "El textContentType asignado a emailTextField no es el correcto, debería ser EmailAddress.")
        XCTAssertEqual(vc.phoneTextField.textContentType, .telephoneNumber, "El textContentType asignado a phoneTextField no es el correcto, debería ser PhonePad.")
    }
    
    //Con este test busco validar que en el ViewController al presionar el botón Update User, se haga el llamado al ViewModel
    //En este caso se llama a un MockViewModel ya que lo que busco es validar el VC, no el VM.
    //Para ello se creó un MockViewModel que lo que hace es pasar a true una variable que indica que si se llamó luego de presionar el Botón.
    func testUserFormViewController_WhenButtonIsPressed_CallTheProcessUpdateUser(){
        //Preparando las dependencias
        let mockApiManager = MockApiManager()
        let mockViewDelegate = MockUserFormView()
        let mockValidator = MockUserFormValidator()

        //Inyectando las dependencias para el Mock ViewModel
        let mockViewModel = MockUserFormViewModel(apiManager: mockApiManager, viewDelegate: mockViewDelegate, formModelValidator: mockValidator)
        
        //Asigno el MockViewModel al ViewModel real del ViewControlelr
        vc.viewModel = mockViewModel
        
        //Presionando el botón que envía el form.
        vc.updateUserButton.sendActions(for: .touchUpInside)
        
        //Validando que luego de haber presionado el botón, se haya llamado la funcionalidad "viewModel.processUpdateUser"
        XCTAssertTrue(mockViewModel.processUpdateUserCalled, "No se llamó viewModel.processUpdateUser luego de presionar el botón Update User")
    }
    
    func testUserFormViewConroller_ConfigFormInfoReceivedEmptyDataToPrint_ShouldFillupTextFieldsWithEmptyValues(){
        vc.userDataToPrint = UserDataToPrint(id: nil, name: nil, email: nil, phone: nil)
        vc.configFormInfo()
        //Valido que cada campo tenga el valor correcto que se le pasó al instanciar el ViewController a través de userDataToPrint
        XCTAssertEqual(vc.nameTextField.text!, "", "El TextField Name no tiene un valor vacío.")
        XCTAssertEqual(vc.emailTextField.text!, "", "El TextField Email no tiene un valor vacío.")
        XCTAssertEqual(vc.phoneTextField.text!, "", "El TextField Phone no tiene un valor vacío.")
    }
    
    func testUserFormViewController_ShouldCallDelegateSuccessResponseAfterSave(){
        //Esta llamada debería devolver un success al delegate
        let formModelValidator = UserFormValidator()
        let mockViewModel1 = MockUserFormViewModel(apiManager: MockApiManager(), viewDelegate: vc, formModelValidator: formModelValidator)
        vc.viewModel = mockViewModel1
        vc.viewModel.processUpdateUser(userFormModel: UserFormModel.emptyData(), endpoint: .updateUser)
        XCTAssertTrue(mockViewModel1.processUpdateUserCalled, "Esta prueba debió ser sucess")

    }

    func testUserFormViewController_ShouldCallDelegateDidFailValidationForm(){
        //Esta llamada debería devolver un error al delegate
        let formModelValidator2 = UserFormValidator()
        let mockViewModel2 = MockUserFormViewModel(apiManager: MockApiManager(), viewDelegate: vc, formModelValidator: formModelValidator2)
        vc.viewModel = mockViewModel2
        vc.viewModel.processUpdateUser(userFormModel: UserFormModel.emptyData(), endpoint: .usersFetchMock)
        XCTAssertTrue(mockViewModel2.didFailValidationForm, "Esta prueba debió fallar")
    }
}
