//
//  UserFormValidation.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 11/02/21.
//

import Foundation

protocol UserFormValidatorDelegate {
    func isNameValid(name: String)->Bool
    func isEmailValid(email: String)->Bool
    func isPhoneValid(phone: String)->Bool
}

class UserFormValidator : UserFormValidatorDelegate{
    func isNameValid(name: String) -> Bool{
        return (name.count >= userNameMinLength && name.count <= userNameMaxLength)
    }
    
    func isEmailValid(email: String) -> Bool{
        let regex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
                                                "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
                                                "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
                                                "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
                                                "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
                                                "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
                                                "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    func isPhoneValid(phone: String) -> Bool{
        return (phone.count == userPhoneMaxLength && (Int(phone) != nil))
    }
    
    
}
