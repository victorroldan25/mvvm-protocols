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
    @IBOutlet var emailLabel    : UILabel!
    @IBOutlet var phoneLabel    : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    
    var userSelected            : String!
    var viewModel               : UserDetailViewModelDelegate!
    private let apiManager      = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAndHideActivity(show: true)
        setupViewModel()
        fetchUsers()
        generalSetup()
        
    }
    
    private func generalSetup(){
        self.navigationController?.navigationBar.backItem?.accessibilityLabel = "backToUserList1"
    }
    
    private func setupViewModel(){
        viewModel = UserDetailsViewModel(apiManager: apiManager, viewDelegate: self)
    }
    
    func fetchUsers(){
        showAndHideActivity(show: true)
        viewModel.fetchUserById(endpoint: .getUserById(id: userSelected))
    }
    
    private func showAndHideActivity(show : Bool){
        self.activityIndicator.isHidden = !show
        if show{
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showUserInfo(user : UserDataToPrint){
        nameLabel.text      = user.name
        emailLabel.text     = user.email
        phoneLabel.text     = user.phone
    }
}

extension UserDetailViewController : UserDataDelegate{
    func fetchUserData(users: UserDataToPrint) {
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
