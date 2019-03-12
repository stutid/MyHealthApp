//
//  ViewController.swift
//  MyHealthApp
//
//  Created by Stuti on 09/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    var viewModelObj = ViewModel()
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var emailAddressTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelObj.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        setupButtonUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailAddressTextfield.text = ""
        passwordTextfield.text = ""
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if viewModelObj.validateUserCredentials(email: emailAddressTextfield.text!, password: passwordTextfield.text!) {
            SVProgressHUD.show(withStatus: "Logging In...")
            viewModelObj.login(with: emailAddressTextfield.text!, password: passwordTextfield.text!)
        }
        else {
            showErrorMessage()
        }
    }
    
    func showErrorMessage() {
        let alertController = UIAlertController(title: "Message", message: "Please enter email address/password", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupButtonUI() {
        btnLogin.layer.cornerRadius = 10.0
        btnLogin.layer.masksToBounds = true
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: LoginDelegate {
    func proceedLogin() {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

