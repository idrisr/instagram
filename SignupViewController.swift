//
//  SignupViewController.swift
//  Instagram
//
//  Created by dp on 4/13/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UserCreationDelegate, AuthenticationDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let connectionController = ConnectionController.sharedConnection

    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectionController.createUserDelegate = self
        self.connectionController.authenticationDelegate = self

        self.userNameTextField.layer.cornerRadius = 5.0
        self.emailTextField.layer.cornerRadius = 5.0
        self.passwordTextField.layer.cornerRadius = 5.0
        self.signUpButton.layer.cornerRadius = 5.0
    }

    @IBAction func onSignupTapped(sender: AnyObject) {
        let userName = userNameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        connectionController.createUser(email, password: password, userName: userName!)
    }

    // MARK: UserCreationDelegate
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

    // MARK: AuthenticationDelegate
    func userAuthenticatedSuccess() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.performSegueWithIdentifier("signupToFeedSegue", sender: nil)
        }
    }

    func userAuthenticatedFail(error:NSError) {
        // shouldnt be here. optional protocol function in Swift?
        print(error.localizedDescription + "\(error.code)")
    }
}
