//
//  MockUserFormValidator.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 11/02/21.
//

@testable import MVVMCombine
import Foundation

class MockUserFormValidator : UserFormValidatorDelegate{
    var isNameValid  : Bool = false
    var isEmailValid : Bool = false
    var isPhoneValid : Bool = false
    
    func isNameValid(name: String) -> Bool {
        isNameValid = true
        return isNameValid
    }
    
    func isEmailValid(email: String) -> Bool {
        isEmailValid = true
        return isEmailValid
    }
    
    func isPhoneValid(phone: String) -> Bool {
        isPhoneValid = true
        return isPhoneValid
    }
}
