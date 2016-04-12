//
//  LoginViewController.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, CreateUserDelegate {
    let connectionController = ConnectionController.sharedConnection

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // TODO: DO ME IN THE ConnectionManager
    var ref: Firebase?

    override func viewDidLoad() {
        super.viewDidLoad()
        connectionController.createUserDelegate = self

        // TODO: DO ME IN THE ConnectionManager
        self.ref = self.connectionController.ref
    }

    override func viewDidAppear(animated: Bool) {
        // 1
        self.ref!.observeAuthEventWithBlock { (authData) -> Void in
            // 2
            if authData != nil {
                // 3
                self.performSegueWithIdentifier("loginToFeed", sender: nil)
            }
        }
    }

    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        self.ref!.authUser(emailTextField.text, password: passwordTextField.text,
                     withCompletionBlock: { (error, auth) in
        })
    }

    @IBAction func onSignupButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .Alert)

        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in

            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            print("tryign to create user")

            self.ref!.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                if error == nil {
                    self.ref!.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                        print("user authorized")
                    })
                } else {
                    print(error.localizedDescription)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in }

        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }

        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        presentViewController(alert, animated: true, completion: nil)
    }

    func createUser() {}
}