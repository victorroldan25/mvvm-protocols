//
//  MockUserFormView.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 11/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUserFormView : UserFormDelegate{
    var failValidations : Bool = false
    var successResponse : Bool = false
    
    func didFailValidationForm(message: String) {
        failValidations = true
    }
    
    func successResponseAfterSave(message: String) {
        successResponse = true
    }
    
    
}
