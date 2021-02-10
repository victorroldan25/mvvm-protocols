//
//  UserDetailViewTests.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 10/02/21.
//

@testable import MVVMCombine
import XCTest

class UserDetailViewTests: XCTestCase {

    var viewModel : UserDetailsViewModel!
    var viewDelegate = MockUserDetailView()
    
    override func setUpWithError() throws {
        viewModel = UserDetailsViewModel(apiManager: MockApiManager(), viewDelegate: viewDelegate)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testUserDetailView_ShouldReceiveAnUserModel(){
        //Call mock endpoint to get 1 result
        viewModel.fetchUserById(endpoint: .getUserById(id: "1"))
        
        //Evaluate if the responses is an UserModel
        XCTAssertTrue(viewDelegate.receiveUserModel, "Didn't receive the user model properly")
    }
    
    func testUserDetailView_ShouldReceiveAnError(){
        //Call mock endpoint to get 1 result
        viewModel.fetchUserById(endpoint: .usersFetchMock)
        
        //Evaluate if the response is an error.
        XCTAssertTrue(viewDelegate.receiveErrorFetchingData, "Didn't receive the error properly")
    }
    
    //Unit test
    func testUserDetailView_ReceiveAnUserModel_ShouldReturnDataToPrintModel(){
        //Create a mock UserModel
        let userModelMock = UserModel(id: 1, name: "John", username: "johndoe", email: "jonhdou@test.com", phone: "1234567")
        
        //Call the formatDate to convert from UserModel to UserDataToPrint
        let formattedData = viewModel.formatData(users: userModelMock)
        
        //Assert if the returned data comply with the correct format.
        XCTAssertTrue(formattedData.name == "Name: "+userModelMock.name!)
        XCTAssertTrue(formattedData.email == "Email: "+userModelMock.email!)
        XCTAssertTrue(formattedData.phone == "Phone: "+userModelMock.phone!)
        
    }

}
