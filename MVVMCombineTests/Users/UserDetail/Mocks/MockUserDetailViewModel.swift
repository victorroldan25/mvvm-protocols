//
//  MockUserDetailViewModel.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUserDetailViewModel : UserDetailViewModelDelegate{
    var fetchUserByIdCalled  : Bool = false
    var failedFetchingData   : Bool = false
    private var viewDelegate : UserDataDelegate!
    
    required init(apiManager: APIManagerDelegate, viewDelegate: UserDataDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func fetchUserById(endpoint: Endpoint) {
        if endpoint == .usersFetchMock{
            failedFetchingData = true
            viewDelegate.failedFetchingData(error: errorMessage.basicError)
        }
        fetchUserByIdCalled = true
    }
}
