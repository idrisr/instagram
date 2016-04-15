//
//  LoginViewController.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, AuthenticationDelegate  {

    let connectionController = ConnectionController.sharedConnection

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        self.connectionController.authenticationDelegate = self
        self.loginButton.layer.cornerRadius = 5.0
        self.signupButton.layer.cornerRadius = 5.0
        self.emailTextField.layer.cornerRadius = 5.0
        self.passwordTextField.layer.cornerRadius = 5.0
    }

    // MARK: IBActions
    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        connectionController.loginUser(email, password: password)
    }

    // MARK: AuthenticationDelegate
    func userAuthenticatedSuccess() {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("segueToFeed", sender: nil)
        }
    }

    func userAuthenticatedFail(error:NSError) {
        print(error.localizedDescription + "\(error.code)")
        var message: String
        switch error.code {
        case -5:
            message = "Invalid email address"
        case -6:
            message = "Incorrect Password"
        case -8:
            message = "No account for that email address"
        default:
            message =  "error logging in"
        }

        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}