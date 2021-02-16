//
//  MockUsersViewModel.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUsersViewModel : UserViewModelDelegate{
    var fetchusersCalled : Bool = false
    required init(apiManager: APIManagerDelegate) {
        //Nothing
    }
    
    func fetchUsers(endpoint: Endpoint, completion: @escaping (Result<[UserDataToPrint], Error>) -> Void) {
        fetchusersCalled = true
    }
}
