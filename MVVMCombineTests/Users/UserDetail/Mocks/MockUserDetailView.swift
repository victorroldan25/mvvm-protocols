//
//  MockUserDetailView.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 10/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUserDetailView : UserDataDelegate{
    
    var receiveUserModel : Bool = false
    var receiveErrorFetchingData  : Bool = false
    
    func fetchUserData(users: UserDataToPrint) {
        if let _ = users.id{
            receiveUserModel = true
        }
    }
    
    func failedFetchingData(error: Error) {
        receiveErrorFetchingData = true
    }
}
