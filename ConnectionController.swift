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
    func userAuthenticated()
}

class ConnectionController {

    var posts = [Post]()

    var reloadPostsDelegate: ReloadPostsDelegate?
    var createUserDelegate: CreateUserDelegate?
    var authenticationDelegate: AuthenticationDelegate?

    // private
    var user: User?

    let ref = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/")
    let postsRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/posts")
    let usersRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/users")

    static let sharedConnection = ConnectionController()

    func allPosts() {
        postsRef.observeEventType(.Value, withBlock: { snapshot in
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
        let childRef = self.postsRef.childByAutoId()
        childRef.setValue(post.toAnyObject())
    }

    func createUser(email:String?, password:String?, uid: String) {
        self.ref!.createUser(email, password: password) { (error: NSError!, results: [NSObject : AnyObject]!) in
            if error == nil {
                self.loginUser(email, password: password)
                let uid = results["uid"] as! String
                let childRef = self.usersRef.childByAppendingPath(uid)
                self.user = User(email: email!, uid: uid, ref: childRef)
                childRef.setValue(self.user!.toAnyObject())
            } else {
                print(error.localizedDescription)
            }
        }
    }

    func loginUser(email: String?, password: String?) {
        self.ref!.authUser(email, password: password,
                     withCompletionBlock: { (error, auth) in
                        if (error == nil) {
                            self.authenticationDelegate?.userAuthenticated()
                            let UID = auth.uid
                            let userRef = self.usersRef.childByAppendingPath(UID)
                            userRef.observeEventType(.Value, withBlock: { (snapshot: FDataSnapshot!) in
                                self.user = User(snapshot: snapshot)
                                print(self.user?.email)
                            })

                        } else {
                            print(error.localizedDescription)
                        }
        })
    }
}