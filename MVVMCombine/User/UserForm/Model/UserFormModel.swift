//
//  UserFormModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 11/02/21.
//

import Foundation


struct UserFormModel{
    var name : String?
    var email : String?
    var phone : String?
    
    static func emptyData()->UserFormModel{
        return UserFormModel(name: "", email: "", phone: "")
    }
}
