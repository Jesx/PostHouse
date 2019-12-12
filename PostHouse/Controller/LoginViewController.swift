//
//  LoginViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import PKHUD
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        accountTextField.text = ""
//        passwordTextField.text = ""
        
        buttonApparance(loginButton, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        buttonApparance(signUpButton, color: #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    func buttonApparance(_ sender: UIButton, color: CGColor) {
        sender.layer.borderWidth = 2
        sender.layer.borderColor = color
        sender.layer.cornerRadius = 5
        sender.clipsToBounds = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        
        let name = accountTextField.text
        let password = passwordTextField.text
        
        if (name?.isEmpty)! || name?.trimmingCharacters(in: .whitespaces) == "" || (password?.isEmpty)! {
            
            HUD.flash(.labeledError(title: "名稱或密碼錯誤", subtitle: "請輸入正確名稱或密碼"), delay: 1)
                   
        } else {
            
            PostHouseData().login(username: name!, password: password!) { (response) in
                
                if response.message != "Username not found" && response.message != "Wrong password" {
                    
                    token = (response.data?.api_token)!
//                    print(token)
                    DispatchQueue.main.async {
                        
                        HUD.flash(.labeledSuccess(title: "登入成功", subtitle: "\((response.data?.username)!) 歡迎回來"), onView: nil, delay: 1) { (_) in
                            if response.data?.role_name == "station" {
                               let vc = self.storyboard?.instantiateViewController(identifier: "SelectedStationVC") as! SelectedStationViewController
                                self.present(vc, animated: true) {
                                    self.accountTextField.text = ""
                                    self.passwordTextField.text = ""
                                }
                                
                            } else if response.data?.role_name == "runner" {
                                
                                let vc = self.storyboard?.instantiateViewController(identifier: "FreightListTVC") as! UITabBarController
                                self.present(vc, animated: true) {
                                    self.accountTextField.text = ""
                                    self.passwordTextField.text = ""
                                }
                            }
                        }
        
                    }
                } else {
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "名稱或密碼錯誤", subtitle: response.message), delay: 1)
                    }
                }
            }
        }
        
    }
//    @IBAction func didTapSignUp(_ sender: UIButton) {
//        let alert = UIAlertController(title: "請洽系統管理員", message: "請寄 email 至：123@gmail.com", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }
    
}

extension LoginViewController: UITextFieldDelegate {
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
