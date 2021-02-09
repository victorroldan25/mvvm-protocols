//
//  UsersViewModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 26/01/21.
//

import Foundation
import Combine

protocol UserFetchProtocol {
    func showUsers(userData : [UserDataToPrint])
}

class UsersViewModel{
    private let apiManager : APIManager
    private let endpoint   : Endpoint
    var usersSubject       = PassthroughSubject<[UserDataToPrint], Error>()
    
    init(apiManager : APIManager, endpoint : Endpoint){
        self.apiManager = apiManager
        self.endpoint = endpoint
    }
    
    func fetchUsers(completion : @escaping (Result<[UserDataToPrint], Error>) -> Void){
        let url = URL(string: endpoint.urlString)!
        
        apiManager.fetchItems(url: url) { [weak self] (result : Result<[UserModel], Error>) in
            switch result{
            case .success(let users):
                let userDataToPrint = (self?.formatData(users: users)) ?? [UserDataToPrint.emptyData()]
                completion(.success(userDataToPrint))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func formatData(users : [UserModel])->[UserDataToPrint]{
        users.map {
            UserDataToPrint(id: String($0.id!),
                            name:  "Name: "+$0.name!,
                            email: "Email: "+$0.email!,
                            phone: "Phone: "+$0.phone!)
        }
    }
}

struct UserDataToPrint{
    let id    : String?
    let name  : String?
    let email : String?
    let phone : String?
    
    static func emptyData()->UserDataToPrint{
        return UserDataToPrint(id: "", name: "", email: "", phone: "")
    }
}
