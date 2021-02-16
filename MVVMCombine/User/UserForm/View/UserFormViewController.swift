//
//  UserFormViewController.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 10/02/21.
//

import UIKit

class UserFormViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var nameTextField    : UITextField!
    @IBOutlet weak var emailTextField   : UITextField!
    @IBOutlet weak var phoneTextField   : UITextField!
    @IBOutlet weak var updateUserButton : UIButton!
    //Vars
    var viewModel : UserFormViewModelDelegate!
    var userDataToPrint : UserDataToPrint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configFormInfo()
    }
    
    private func configFormInfo(){
        updateUserButton.accessibilityIdentifier = "updateUserButton"
        title = "Update User"
        nameTextField.text  = userDataToPrint.name  ?? ""
        emailTextField.text = userDataToPrint.email ?? ""
        phoneTextField.text = userDataToPrint.phone ?? ""
    }
    
    private func configViewModel(){
        let formModelValidator = UserFormValidator()
        viewModel = UserFormViewModel(apiManager: APIManager(), viewDelegate: self, formModelValidator: formModelValidator)
    }
    
    @IBAction func userUpdateButtonPressed(_ sender: Any) {
        let userFormModel = UserFormModel(name: nameTextField.text,
                                          email: emailTextField.text,
                                          phone: phoneTextField.text)
        
        viewModel.processUpdateUser(userFormModel: userFormModel)
    }
    

}

extension UserFormViewController : UserFormDelegate{
    func didFailValidationForm(message: String) {
        CustomAlert.show(in: self, withMessage: message, withTitle: "Validation Failed")
    }
    
    func successResponseAfterSave(message: String) {
        CustomAlert.show(in: self, withMessage: message)
    }
}
