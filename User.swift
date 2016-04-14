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
    var postIDs : [String]
    var bio: String?

    // init from device
    init(email: String, uid:String, ref: Firebase) {
        self.email = email
        self.uid = uid
        self.name = ""
        self.username = ""
        self.ref = ref
        self.postIDs = []
        self.bio = ""
    }

    // init from firebase
    init(snapshot: FDataSnapshot) {
        self.name = snapshot.value["name"] as! String?
        self.email = snapshot.value["email"] as! String
        self.bio = snapshot.value["bio"] as! String?
        self.username = ""
        self.ref = snapshot.ref
        self.uid = snapshot.key
        // set postIDs
        if let posts = snapshot.value?["posts"] as? [String] {
            self.postIDs = posts
        } else {
            self.postIDs = []
        }
    }

    mutating func addPost(postID:String) {
        postIDs.append(postID)
    }

    func toAnyObject() -> AnyObject {
        return [ "name": name!, "username": username!, "email": email, "posts": postIDs, "bio": bio!]
    }
}