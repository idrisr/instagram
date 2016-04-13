//
//  LoginViewController.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, AuthenticationDelegate {

    let connectionController = ConnectionController.sharedConnection

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        self.connectionController.authenticationDelegate = self
    }

    // MARK: IBActions
    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        connectionController.loginUser(email, password: password)
    }

    @IBAction func onSignupButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        connectionController.createUser(email, password: password, uid: "")
    }

    // MARK: AuthenticationDelegate
    func userAuthenticated() {
        performSegueWithIdentifier("segueToFeed", sender: nil)
    }
}