//
//  UserModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 26/01/21.
//

import Foundation

struct UserModel : Codable{
    var id       : Int?
    var name     : String?
    var username : String?
    var email    : String?
    var phone    : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
        case phone
    }
}
