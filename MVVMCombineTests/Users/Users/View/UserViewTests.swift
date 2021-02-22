//
//  UserViewTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 9/02/21.
//

import XCTest
@testable import MVVMCombine
import Foundation

class UserViewTests: XCTestCase {

    var viewModel : UsersViewModel!
    var apiManager = MockApiManager()
    
    override func setUpWithError() throws {
        viewModel = UsersViewModel(apiManager: apiManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testCallUsers_ShouldReturnListOfUsers(){
        viewModel.fetchUsers(endpoint: .usersFetch) {(result : Result<[UserDataToPrint], Error>) in
            switch result{
            case .success(let users):
                XCTAssertTrue(users.count>0, "Esto debería retornar un listado de UserDataToPrint")
            case .failure(let error):
                XCTAssertNil(error, "Este error debería ser nil")
            }
        }
    }
    func testCallUsers_ShouldReturnFailure(){
        viewModel.fetchUsers(endpoint: .usersFetchMock) {(result : Result<[UserDataToPrint], Error>) in
            switch result{
            case .success(let users):
                XCTAssertTrue((users.count==0), "No se debería recibir ningún usuario aquí")
            case .failure(let error):
                XCTAssertNotNil(error, "El error no debería ser nil")
            }
        }
    }
    
    //Unit test
    func testUserView_ReceiveAnUserModelList_ShouldReturnDataToPrintModelList(){
        //Create a mock UserModel
        let userModelMock = [
            UserModel(id: 1, name: "John 1", username: "johndoe1", email: "jonhdou1@test.com", phone: "39429330"),
            UserModel(id: 2, name: "John 2", username: "johndoe2", email: "jonhdou2@test.com", phone: "34923949"),
            UserModel(id: 3, name: "John 3", username: "johndoe3", email: "jonhdou3@test.com", phone: "32943239"),
        ]
        
        //Llamar el método formatData para convertir de UserModel to UserDataToPrint
        let formattedData = viewModel.formatData(users: userModelMock)
        
        //Assertion to validate if it received a list
        XCTAssertTrue(formattedData.count>0, "Se debería recibir un listado de UserDataToPrint")
        
        //Assertion if the returned data comply with the correct format.
        XCTAssertTrue(formattedData.first!.name == "Name: "+userModelMock.first!.name!)
        XCTAssertTrue(formattedData.first!.email == "Email: "+userModelMock.first!.email!)
        XCTAssertTrue(formattedData.first!.phone == "Phone: "+userModelMock.first!.phone!)
        
    }
}
