//
//  UserDetailViewController.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 3/02/21.
//

import UIKit
import Combine

class UserDetailViewController: UIViewController {

    @IBOutlet var nameLabel     : UILabel!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var emailLabel    : UILabel!
    @IBOutlet var phoneLabel    : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    
    var userSelected            : String!
    private var viewModel       : UserDetailsViewModel!
    private let apiManager      = APIManager()
    private var cancellable     = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAndHideActivity(show: true)
        setupViewModel()
        fetchUsers()
        
    }
    
    private func setupViewModel(){
        viewModel = UserDetailsViewModel(apiManager: apiManager,
                                         endpoint: .getUserById(id: userSelected),
                                         viewDelegate: self)
    }
    
    private func fetchUsers(){
        showAndHideActivity(show: true)
        viewModel.fetchUserById()
    }
    
    private func showAndHideActivity(show : Bool){
        self.activityIndicator.isHidden = !show
        if show{
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func showUserInfo(user : UserModel){
        nameLabel.text      = user.name
        usernameLabel.text  = user.username
        emailLabel.text     = user.email
        phoneLabel.text     = user.phone
    }
}

extension UserDetailViewController : UserDataDelegate{
    func fetchUserData(users: UserModel) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.showUserInfo(user: users)
            self.showAndHideActivity(show: false)
        }
    }
    
    func failedFetchingData(error: Error) {
        print("Error: ", error.localizedDescription)
        showAndHideActivity(show: false)
    }
    
    
}
