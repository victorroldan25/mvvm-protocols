//
//  MockUserDetailViewModel.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUserDetailViewModel : UserDetailViewModelDelegate{
    var fetchUserByIdCalled : Bool = false
    
    required init(apiManager: APIManagerDelegate, viewDelegate: UserDataDelegate) {
        //Nothing
    }
    
    func fetchUserById(endpoint: Endpoint) {
        fetchUserByIdCalled = true
    }
}
