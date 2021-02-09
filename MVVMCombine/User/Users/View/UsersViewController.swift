//
//  ViewController.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 26/01/21.
//

import UIKit

class UsersViewController: UIViewController {
    
    var viewModel           : UsersViewModel!
    private let apiManager  = APIManager()
    var users               : [UserDataToPrint] = []
    static let cellId       = "CustomCell"
    
    var tableView : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 115
        let nibName = UINib(nibName: UsersViewController.cellId, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: UsersViewController.cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        generalSetup()
        setupViewModel()
        fetchUsers()
        
    }
    private func generalSetup(){
        title = "User List"
    }
    
    private func tableViewSetup(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupViewModel(){
        viewModel = UsersViewModel(apiManager: apiManager, endpoint: .usersFetch)
    }
    
    private func fetchUsers(){
        viewModel.fetchUsers {[weak self] (result : Result<[UserDataToPrint], Error>) in
            switch result{
            case .success(let users):
                self?.users = users
                self?.tableView.reloadData()
                
            case .failure(let error):
                print("error: ", error.localizedDescription)
            }
        }
    }
    
    override func loadView() {
        view = tableView
    }
}

extension UsersViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewController.cellId, for: indexPath) as! CustomCell
        let user = self.users[indexPath.row]
        cell.configCell(userData: user)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToViewDetail(indexPath: indexPath)
        
    }
    
    private func goToViewDetail(indexPath : IndexPath){
        let userSelected = self.users[indexPath.row]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "userDetailsVC") as! UserDetailViewController
        vc.userSelected = userSelected.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UsersViewController : CellCustomDelegate{
    func didTapCell(modelSelected: UserDataToPrint) {
        print("name: ", modelSelected.name ?? "")
    }
}
