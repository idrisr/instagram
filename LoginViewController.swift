//
//  LoginViewController.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, AuthenticationDelegate, UserCreationDelegate {

    let connectionController = ConnectionController.sharedConnection

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        self.connectionController.authenticationDelegate = self
        self.connectionController.createUserDelegate = self
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
    func userAuthenticatedSuccess() {
        performSegueWithIdentifier("segueToFeed", sender: nil)
    }

    func userAuthenticatedFail(error:NSError) {
        var message: String
        switch error.code {
        case -5:
            message = "Invalid email address"
        case -6:
            message = "Incorrect Password"
        default:
            message =  "error logging in"
        }

        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func createUserFail(error: NSError) {
        var message: String
        switch error.code {
        case -5:
            message = "Invalid email address"
        case -9:
            message = "The specified email address is already in use"
        default:
            message =  "error creating user"
        }

        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}