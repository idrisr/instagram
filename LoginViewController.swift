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
        connectionController.authorizeUser(email, password: password)
    }

    @IBAction func onSignupButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        connectionController.createFirebaseUserWithEmail(email, password: password)
    }

    // MARK: AuthenticationDelegate
    func didAuthenticate() {
        performSegueWithIdentifier("segueToFeed", sender: nil)
    }
}