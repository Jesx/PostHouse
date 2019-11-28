//
//  SignUpViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userIdentity: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonApparance(signUpButton, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        buttonApparance(backButton, color: #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        userIdentity.isEnabled = false
    }

    func buttonApparance(_ sender: UIButton, color: CGColor) {
        sender.layer.borderWidth = 2
        sender.layer.borderColor = color
        sender.layer.cornerRadius = 5
        sender.clipsToBounds = true
    }
  
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let name = accountTextField.text
        let password = passwordTextField.text
        
        var alert = UIAlertController()
        var okAction = UIAlertAction()
        
        if (name?.isEmpty)! || name?.trimmingCharacters(in: .whitespaces) == "" || (password?.isEmpty)! {
            
            alert = UIAlertController(title: "名稱錯誤", message: "請輸入正確名稱", preferredStyle: .alert)
            okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            PostHouseData().signUp(role: "station", username: name!, password: password!) {
                
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case accountTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
