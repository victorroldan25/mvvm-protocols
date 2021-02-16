//
//  UsersViewControllerTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import XCTest

class UsersViewControllerTests: XCTestCase {
    var storyboard : UIStoryboard!
    var vc : UsersViewController!
    var navigationController : UINavigationController!
    
    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: "usersVC") as? UsersViewController
        vc.loadViewIfNeeded()
        navigationController = UINavigationController(rootViewController: vc)
    }

    override func tearDownWithError() throws {
        storyboard = nil
        vc         = nil
    }

    func testUsersViewController_WhenLoadViewController_ShouldCallFetchUsers(){
        let mockViewModel = MockUsersViewModel(apiManager: MockApiManager())
        vc.viewModel = mockViewModel
        vc.fetchUsers()
        
        XCTAssertTrue(mockViewModel.fetchusersCalled, "No se llamó el método viewModel.fetchUsers desde el ViewController")
    }
    
    func testUsersViewController_ValidateTableViewHasItsIBOutletAndTheIdentifier() throws{
        let tableView = try XCTUnwrap(vc.tableView, "El tableView no tiene su IBOutlet.")
        
        XCTAssertEqual(tableView.accessibilityIdentifier, tableViewAcceibilityIdentifier, "El TableView no tiene el identificador correcto.")
    }
    
    func testUsersViewController_ValidateIfTheNavigationBarTitleIsCorrect(){
        XCTAssertEqual(vc.title, "User List", "El título del NavigationBar no es correcto")
    }
    
    func testUsersViewController_AfterSelectingOneOptionIntoTableView_ShouldGoToUserDetailViewController(){
        //Inyecto dependencias al VM real y llamo al servicio
        let mockViewModel = UsersViewModel(apiManager: MockApiManager())
        vc.viewModel = mockViewModel
        vc.fetchUsers()
        
        //Hago tap en la fila completa para navegar a la siguiente pantalla
        let indexPath = IndexPath(row: 0, section: 0)
        vc.tableView.delegate?.tableView?(vc.tableView, didSelectRowAt: indexPath)
        
        //Esto es para que espere la animación del pushViewController
        RunLoop.current.run(until: Date())

        //Valido que el próximo viewController sea el correcto
        guard let _ = navigationController.topViewController as? UserDetailViewController else{
            XCTFail("El view que se está mostrando luego de seleccionar una opción, no es el correcto")
            return
        }
    }
    
    func testUsersViewController_AfterSelectingOneOptionIntoTableView_ShouldGoToUserForm(){
        //Inyecto dependencias al VM real y llamo al servicio
        let mockViewModel = UsersViewModel(apiManager: MockApiManager())
        vc.viewModel = mockViewModel
        vc.fetchUsers()
        
        //Como el APIManager es un Mock, obtengo los 10 resultados atomáticamente.
        //Selecciono la primera fila y presiono el Botón Update para que redireccione al Formulario.
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = vc.tableView.cellForRow(at: indexPath) as? CustomCell
        cell?.updateButton.sendActions(for: .touchUpInside)
        
        //Esto es para que espere la animación del pushViewController
        RunLoop.current.run(until: Date())

        //Valido que el próximo viewController sea el correcto
        guard let _ = navigationController.topViewController as? UserFormViewController else{
            XCTFail("El view que se está mostrando luego de seleccionar el botón update, no es el correcto")
            return
        }
    }
}
