//
//  ConnectionController.swift
//  Instagram
//
//  Created by id on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import Foundation
import Firebase

// functionality needed:

/*
posts added
posts deleted

comments added
comments deleted

likes added
likes deleted
*/

//  define protocol
protocol ReloadPostsDelegate {
    func reloadModel()
}

protocol SavePostDelegate {
    func savePost(post:Post)
}

protocol CreateUserDelegate {
    func createFirebaseUserWithEmail(_:String, password:String)
}

protocol AuthenticationDelegate {
    func didAuthenticate()
}

class ConnectionController {
    let ref = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/")
    let postRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/posts")
    let userRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/users")

    var posts = [Post]()

    var reloadPostsDelegate: ReloadPostsDelegate?
    var createUserDelegate: CreateUserDelegate?
    var authenticationDelegate: AuthenticationDelegate?

    static let sharedConnection = ConnectionController()

    func allPosts() {
        postRef.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let post = Post(snapshot: item as! FDataSnapshot)
                if !self.posts.contains(post) {
                    self.posts.append(post)
                }
            }
            self.posts = self.posts.reverse()
            self.reloadPostsDelegate?.reloadModel()
        })
    }

    func savePost(post: Post) {
        let childRef = self.postRef.childByAutoId()
        childRef.setValue(post.toAnyObject())
    }

    func createFirebaseUserWithEmail(email:String?, password:String?) {
        // TODO guard against nils for email and password

        // create firebase authentication user
        self.ref!.createUser(email, password: password) { (error: NSError!) in
            if error == nil {
                self.authorizeUser(email, password: password)
            } else {
                print(error.localizedDescription)
            }
        }

        // create user object
        let user = User(email: email!)
        let childRef = self.userRef.childByAutoId()
        childRef.setValue(user.toAnyObject())
    }

    func authorizeUser(email: String?, password: String?) {
        self.ref!.authUser(email, password: password,
                     withCompletionBlock: { (error, auth) in
                        self.authenticationDelegate?.didAuthenticate()
        })
    }
}