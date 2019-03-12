//
//  ViewModel.swift
//  MyHealthApp
//
//  Created by Stuti on 09/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation

protocol LoginDelegate: class {
    func proceedLogin()
}

class ViewModel {
    
    weak var delegate: LoginDelegate?
    private let apiManager = ApiManager()
    
    func validateUserCredentials(email: String, password: String) -> Bool {
        if email == "" || password == "" {
            return false
        }
        return true
    }
    
    func login(with email: String, password: String){
        apiManager.postData(with: loginPostURL, and: ["username": email, "password": password]) { (data, error) in
            self.delegate?.proceedLogin()
        }
    }
}
