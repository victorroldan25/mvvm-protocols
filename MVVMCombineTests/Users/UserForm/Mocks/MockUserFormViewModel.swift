//
//  MockUserFormViewModel.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 16/02/21.
//

import Foundation
@testable import MVVMCombine

class MockUserFormViewModel : UserFormViewModelDelegate{
    var processUpdateUserCalled : Bool = false
    
    required init(apiManager: APIManagerDelegate, viewDelegate: UserFormDelegate, formModelValidator: UserFormValidatorDelegate) {
        //Nothing
    }
    
    func processUpdateUser(userFormModel: UserFormModel) {
        processUpdateUserCalled = true
    }
    
    
}
