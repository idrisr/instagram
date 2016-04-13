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
    var name: String?
    var username: String?
    var email: String
    let ref: Firebase?
    var uid: String

    // init from device
    init(email: String, uid:String, ref: Firebase) {
        self.email = email
        self.uid = uid
        self.name = ""
        self.username = ""
        self.ref = ref
    }

    // init from firebase
    init(snapshot: FDataSnapshot) {
        self.name = snapshot.value["name"] as! String?
        self.email = snapshot.value["email"] as! String
        self.ref = snapshot.ref
        self.uid = snapshot.key
    }

    func toAnyObject() -> AnyObject {
        return [ "name": name!, "username": username!, "email": email ]
    }
}