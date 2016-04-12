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
    var email: String
    let ref: Firebase?
    var id: String?
    var password: String

    func toAnyObject() -> AnyObject {
        return ["id": ""]
    }

//    // init from firebase
//    init(snapshot: FDataSnapshot) {
//    }

    // init from device
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.name = ""
        self.ref = nil
    }
}