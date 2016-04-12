//
//  User.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

struct User {
    var name: String
    var username: String
    var email: String
    let ref: Firebase?
    var id: String?

//    // init from firebase
//    init(snapshot: FDataSnapshot) {
//    }

    // init from device
    init(email: String) {
        self.email = email
        self.name = ""
        self.username = ""
        self.ref = nil
    }

    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "username": username,
            "email": email
        ]
    }
}