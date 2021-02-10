//
//  UserDetailsViewModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 3/02/21.
//

import Foundation


protocol UserDataDelegate {
    func fetchUserData(users : UserDataToPrint)
    func failedFetchingData(error : Error)
}

class UserDetailsViewModel{
    private let apiManager   : APIManagerDelegate
    private var viewDelegate : UserDataDelegate?
    
    init(apiManager : APIManagerDelegate, viewDelegate : UserDataDelegate){
        self.apiManager = apiManager
        self.viewDelegate = viewDelegate
    }
    
    func fetchUserById(endpoint : Endpoint){
        apiManager.fetchItems(endpoint: endpoint) { [weak self] (result : Result<UserModel, Error>) in
            switch result{
            case .success(let users):
                let formatedData = self?.formatData(users: users)
                self?.viewDelegate?.fetchUserData(users: formatedData!)
                
            case .failure(let error):
                self?.viewDelegate?.failedFetchingData(error: error)
            }
        }
    }
    
    func formatData(users : UserModel)->UserDataToPrint{
        UserDataToPrint(id: String(users.id!),
                        name:  "Name: "+users.name!,
                        email: "Email: "+users.email!,
                        phone: "Phone: "+users.phone!)
        
    }
}
