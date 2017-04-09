//
//  AuthenticationVC.swift
//  MimoiOSCodingChallenge
//
//  Created by Rodrigo Suhr on 4/9/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit

@objc class AuthenticationVC: UIViewController, AuthUtilsProtocol {
    @IBOutlet weak var btnChangeAuth: UIButton!
    @IBOutlet weak var btnAuth: UIButton!
    @IBOutlet weak var lblAuth: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPasswd: UITextField!
    @IBOutlet weak var lblErrorMsg: UILabel!
    var isLogIn: Bool = true
    let authUtils: AuthUtils = AuthUtils()

    override func viewDidLoad() {
        super.viewDidLoad()
        authUtils.delegate = self
        lblErrorMsg.text = ""
    }

    @IBAction func onLogInSignUp(_ sender: UIButton) {
        lblErrorMsg.text = ""
        
        if (self.isLogIn) {
            authUtils.logIn(tfEmail.text!, tfPasswd.text!)
        } else {
            authUtils.signUp(tfEmail.text!, tfPasswd.text!)
        }
    }
    
    @IBAction func onChange(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.lblErrorMsg.text = ""
            
            if (self.isLogIn) {
                self.isLogIn = false
                self.lblAuth.text = "Sign Up for Mimo"
                self.tfEmail.placeholder = "jared@piedpiper.com"
                self.tfPasswd.placeholder = "mimo app password"
                sender.titleLabel?.text = "Already have an Account? Log In."
                self.btnAuth.titleLabel?.text = "Sign Up"
            } else {
                self.isLogIn = true
                self.lblAuth.text = "Log In to Mimo"
                self.tfEmail.placeholder = "Email"
                self.tfPasswd.placeholder = "Password"
                sender.titleLabel?.text = "Don't have an Account? Sign up."
                self.btnAuth.titleLabel?.text = "Log In"
            }
        }
    }
    
    func onSignupError(message: String) {
        lblErrorMsg.text = message
    }
    
    func onLoginSuccess() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc: SettingsViewController = SettingsViewController()
        appDelegate.loadVC(vc)
    }
    
    func onLoginError(message: String) {
        lblErrorMsg.text = message
    }
}
