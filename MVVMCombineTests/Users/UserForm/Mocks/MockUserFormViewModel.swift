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
    var didFailValidationForm   : Bool = false
    private var viewDelegate    : UserFormDelegate!
    
    required init(apiManager: APIManagerDelegate, viewDelegate: UserFormDelegate, formModelValidator: UserFormValidatorDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func processUpdateUser(userFormModel: UserFormModel, endpoint: Endpoint) {
        if endpoint == .usersFetchMock{
            didFailValidationForm = true
            viewDelegate.didFailValidationForm(message: "Failed")
        }
        viewDelegate.successResponseAfterSave(message: "Success")
        processUpdateUserCalled = true
    }
    
    
}
