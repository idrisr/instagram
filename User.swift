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
    var followingIDs : [String]
    var followerIDs : [String]

    // init from device
    init(email: String, uid:String, userName: String, ref: Firebase) {
        self.email = email
        self.uid = uid
        self.name = ""
        self.username = userName
        self.ref = ref
        self.postIDs = []
        self.followingIDs = []
        self.followerIDs = []
    }

    // init from firebase
    init(snapshot: FDataSnapshot) {
        self.name = snapshot.value["name"] as! String?
        self.email = snapshot.value["email"] as! String
        self.username = ""
        self.ref = snapshot.ref
        self.uid = snapshot.key

        // set postIDs
        if let posts = snapshot.value?["posts"] as? [String] {
            self.postIDs = posts
        } else {
            self.postIDs = []
        }

        // set followerIDs
        if let followers = snapshot.value?["followers"] as? [String] {
            self.followerIDs = followers
        } else {
            self.followerIDs = []
        }

        // set postIDs
        if let followings = snapshot.value?["followings"] as? [String] {
            self.followingIDs = followings
        } else {
            self.followingIDs = []
        }
    }

    mutating func addPost(postID:String) {
        postIDs.append(postID)
    }

    mutating func addFollowingIDs(userID:String) {
        followingIDs.append(userID)
    }

    func toAnyObject() -> AnyObject {
        return [ 
            "name"          : name!,
             "username"     : username!,
             "email"        : email,
             "posts"        : postIDs,
             "followingIDs" : followingIDs,
             "followerIDs"  : followerIDs
        ]
    }
}
