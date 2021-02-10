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
    private let apiManager : APIManagerDelegate
    
    init(apiManager : APIManagerDelegate){
        self.apiManager = apiManager
    }
    
    func fetchUsers(endpoint: Endpoint, completion : @escaping (Result<[UserDataToPrint], Error>) -> Void){
        
        apiManager.fetchItems(endpoint : endpoint) { [weak self] (result : Result<[UserModel], Error>) in
            switch result{
            case .success(let users):
                let userDataToPrint = self?.formatData(users: users)
                completion(.success(userDataToPrint!))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func formatData(users : [UserModel])->[UserDataToPrint]{
        users.map {
            UserDataToPrint(id: String($0.id!),
                            name:  "Name: "+$0.name!,
                            email: "Email: "+$0.email!,
                            phone: "Phone: "+$0.phone!)
        }
    }
}
