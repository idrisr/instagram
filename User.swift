//
//  User.swift
//  Instagram
//
//  Created by id on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

// Implement Equatable
func ==(lhs:User, rhs:User) -> Bool { // Implement Equatable
    return lhs.uid == rhs.uid
}

struct User:Equatable {
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
        self.username = snapshot.value["username"] as! String
        self.ref = snapshot.ref
        self.uid = snapshot.key

        // set postIDs
        if let posts = snapshot.value?["posts"] as? [String] {
            self.postIDs = posts
        } else {
            self.postIDs = []
        }

        // set followerIDs
        // stringy typed fucking code!!
        if let followers = snapshot.value?["followerIDs"] as? [String] {
            self.followerIDs = followers
        } else {
            self.followerIDs = []
        }

        // set followingIDs
        if let followings = snapshot.value?["followingIDs"] as? [String] {
            self.followingIDs = followings
        } else {
            self.followingIDs = []
        }
    }

    mutating func addPost(postID:String) {
        if !postIDs.contains(postID) {
            postIDs.append(postID)
        }
    }

    mutating func addFollowing(user:User) {
        followingIDs.append(user.uid)
    }

    mutating func addFollower(user:User) {
        followerIDs.append(user.uid)
    }

    mutating func removeFollowing(user:User) {
        if let index = followingIDs.indexOf(user.uid) {
            followingIDs.removeAtIndex(index)
        }
    }

    mutating func removeFollower(user:User) {
        if let index = followerIDs.indexOf(user.uid) {
            followerIDs.removeAtIndex(index)
        }
    }

    func isFollowingUser(user:User) -> Bool {
        return followingIDs.contains(user.uid)
    }

    func isFollowedByUser(user:User) -> Bool {
        return followerIDs.contains(user.uid)
    }

    func doesLikePost(post:Post) -> Bool {
        return post.likes.contains(self.uid)
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
