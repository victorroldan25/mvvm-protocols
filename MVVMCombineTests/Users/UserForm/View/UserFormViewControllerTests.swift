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

    //Con este test busco validar que en el ViewController al presiionar el botón Update User, se haga el llamado al ViewModel
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
    

}
