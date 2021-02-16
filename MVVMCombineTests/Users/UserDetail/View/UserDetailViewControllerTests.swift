//
//  UserDetailViewControllerTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import XCTest

class UserDetailViewControllerTests: XCTestCase {
    /*
    En caso que el view sea un Xib se haría de esta forma
    var xibController = MyXibControllerName!
    xibController = MyXibControllerName()
    xibController.loadViewIfNeeded()
    */
    
    var storyboard : UIStoryboard!
    var vc         : UserDetailViewController!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: "userDetailsVC") as? UserDetailViewController
        vc.userSelected = "1"
        vc.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        storyboard = nil
        vc         = nil
    }

    //En este test se valida que cada UILabel tenga su IBOutlet y que esté vacío cuando se instancia el ViewController.
    func testUserDetailViewController_WhenInstantiateViewController_ShouldHaveIBOutletsAndEmptyLables() throws{
        //Se valida que cada Label tenga su IBOutlet
        let nameLabel  = try XCTUnwrap(vc.nameLabel, "El atributo nameLabel no está conectado a un IBOutlet")
        let emailLabel = try XCTUnwrap(vc.emailLabel, "El atributo emailLabel no está conectado a un IBOutlet")
        let phoneLabel = try XCTUnwrap(vc.phoneLabel, "El atributo phoneLabel no está conectado a un IBOutlet")
        
        //Validar que cada Label esté vacío cuando se instancia el ViewController
        XCTAssertEqual(nameLabel.text!, "", "nameLabel no esta vacío cuando se instanció el ViewController")
        XCTAssertEqual(emailLabel.text!, "", "emailLabel no esta vacío cuando se instanció el ViewController")
        XCTAssertEqual(phoneLabel.text!, "", "phoneLabel no esta vacío cuando se instanció el ViewController")
    }
    
    func testUserDetailViewController_WhenInstantiateTheController_ShouldCallFetchUsers(){
        //Creación de dependencias
        let mockApiManager = MockApiManager()
        let mockViewDelegate = MockUserDetailView()
        
        //Se inyectan las dependencias
        let mockViewModel = MockUserDetailViewModel(apiManager: mockApiManager, viewDelegate: mockViewDelegate)
        
        //Se sustituye el viewModel por el mockViewModel
        vc.viewModel = mockViewModel
        
        //Se hace el llamado al metodo fetchUser que solo pondrá true la bandera de la respuesta.
        vc.fetchUsers()
        
        XCTAssertTrue(mockViewModel.fetchUserByIdCalled, "No se llamó la función fetchUsers cuando se inició el ViewController")
    }
    
    func testUserDetailViewController_WhenRespondFetchUserData_ShouldFillupTheLabels(){
        //Se crea un mock de UserDataToPrint
        let mockUserDataToPrint = UserDataToPrint(id: "1", name: "John Doe", email: "test@test.com", phone: "1234567890")
        
        //Se llama al método showuserInfo para validar si está llenando los UILabels correctamente.
        vc.showUserInfo(user: mockUserDataToPrint)
        
        //Se valida que cada UILabel esté siendo llenado correctamente.
        XCTAssertEqual(vc.nameLabel.text!, mockUserDataToPrint.name ?? "", "El valor del Label nameLabel no es correcto.")
        XCTAssertEqual(vc.emailLabel.text!, mockUserDataToPrint.email ?? "", "El valor del Label emailLabel no es correcto.")
        XCTAssertEqual(vc.phoneLabel.text!, mockUserDataToPrint.phone ?? "", "El valor del Label phoneLabel no es correcto.")
    }
}
