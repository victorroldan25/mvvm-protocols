//
//  UserDetailsViewModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 3/02/21.
//

import Foundation


protocol UserDataDelegate {
    func fetchUserData(users : UserModel)
    func failedFetchingData(error : Error)
}

class UserDetailsViewModel{
    private let apiManager   : APIManager
    private let endpoint     : Endpoint
    private var viewDelegate : UserDataDelegate?
    
    init(apiManager : APIManager, endpoint : Endpoint, viewDelegate : UserDataDelegate){
        self.apiManager = apiManager
        self.endpoint = endpoint
        self.viewDelegate = viewDelegate
    }

    func fetchUserById(){
        let url = URL(string: endpoint.urlString)!
        apiManager.fetchItems(url: url) { [weak self] (result : Result<UserModel, Error>) in
            switch result{
            case .success(let users):
                self?.viewDelegate?.fetchUserData(users: users)

            case .failure(let error):
                self?.viewDelegate?.failedFetchingData(error: error)
            }
        }
    }
}
