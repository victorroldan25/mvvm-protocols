//
//  UserFormViewModel.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 11/02/21.
//

import Foundation

//Se crear un Delegate para poder dar respuesta en el controller que hizo la inyección de dependencias.
protocol UserFormDelegate {
    func didFailValidationForm(message : String)
    func successResponseAfterSave(message : String)
}

//Se crea un delegate para poder crear mocks del ViewModel y así se puedan probar funcionalidades individualmente
protocol UserFormViewModelDelegate {
    init(apiManager : APIManagerDelegate, viewDelegate : UserFormDelegate, formModelValidator : UserFormValidatorDelegate)
    func processUpdateUser(userFormModel : UserFormModel)
}

class UserFormViewModel : UserFormViewModelDelegate{
    private var apiManager          : APIManagerDelegate?
    private var viewDelegate        : UserFormDelegate?
    private var formModelValidator  : UserFormValidatorDelegate
    
    required init(apiManager : APIManagerDelegate, viewDelegate : UserFormDelegate, formModelValidator : UserFormValidatorDelegate){
        self.apiManager = apiManager
        self.viewDelegate = viewDelegate
        self.formModelValidator = formModelValidator
    }
    
    private func validateForm(userForm : UserFormModel)->Bool{
        if !formModelValidator.isNameValid(name: userForm.name ?? ""){
            viewDelegate?.didFailValidationForm(message: "User name is not valid")
            return false
        }
        if !formModelValidator.isEmailValid(email: userForm.email ?? ""){
            viewDelegate?.didFailValidationForm(message: "User email is not valid")
            return false
        }
        if !formModelValidator.isPhoneValid(phone: userForm.phone ?? ""){
            viewDelegate?.didFailValidationForm(message: "User Phone is not valid")
            return false
        }
        return true
    }
    
    func processUpdateUser(userFormModel : UserFormModel){
        if !validateForm(userForm: userFormModel) {return}
        
        //TODO: Call service from here
        viewDelegate?.successResponseAfterSave(message: "The user was updated sucessfully")
        
    }
    
}
