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

protocol ReloadUserPostsDelegate {
    func reloadCollectionView()
}

protocol UserCreationDelegate {
    func createUserFail(error: NSError)
}

protocol AuthenticationDelegate {
    func userAuthenticatedSuccess()
    func userAuthenticatedFail(error: NSError)
}

// protocol to tell controllers that users array changed
protocol UserChangedDelegate {

}

class ConnectionController {

    var posts = [Post]()
    var userPosts = [Post]()
    var reloadPostsDelegate: ReloadPostsDelegate?
    var reloadUserPostsDelegate: ReloadUserPostsDelegate?
    var createUserDelegate: UserCreationDelegate?
    var authenticationDelegate: AuthenticationDelegate?
    var user: User?

    let ref = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/")
    let postsRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/posts")
    let usersRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/users")

    static let sharedConnection = ConnectionController()
    private var users = [User]()

    init() {
        allUsers()
        setupListeners()
    }

    func getUserForUID(uid: String) -> User? {
        // guard instead?
        if let index = self.users.indexOf({$0.uid == uid}) {
            return self.users[index]
        } else {
            return nil
        }
    }

    private func allUsers() {
        usersRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            for item in snapshot.children {
                let user = User(snapshot: item as! FDataSnapshot)
                self.users.append(user)
            }
        }
    }

    // change to listener model and privatize
    func allPosts() {
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let post = Post(snapshot: item as! FDataSnapshot)
                if !self.posts.contains(post) {
                    self.posts.append(post)
                    self.userPosts.append(post)
                }
            }
            self.posts = self.posts.reverse()
            self.reloadPostsDelegate?.reloadModel()
            self.reloadUserPostsDelegate?.reloadCollectionView()
        })
    }
    
    func savePost(post: Post) {
        // save post object
        let childRef = self.postsRef.childByAutoId()

        childRef.setValue(post.toAnyObject()) { (error: NSError!, ref: Firebase!) in
            if error == nil {
                self.user?.addPost(ref.key)
                let userRef = self.usersRef.childByAppendingPath(self.user?.uid)
                userRef.setValue(self.user?.toAnyObject())
            } else {
                print(error.localizedDescription)
            }
        }
    }

    func createUser(email:String?, password:String?, userName: String) {
        self.ref!.createUser(email, password: password) { (error: NSError!, results: [NSObject : AnyObject]!) in
            if error == nil {
                self.loginUser(email, password: password)
                let uid = results["uid"] as! String
                let childRef = self.usersRef.childByAppendingPath(uid)
                self.user = User(email: email!, uid: uid, userName: userName, ref: childRef)
                childRef.setValue(self.user!.toAnyObject())
            } else {
                self.createUserDelegate?.createUserFail(error)
            }
        }
    }

    func loginUser(email: String?, password: String?) {
        self.ref!.authUser(email, password: password,
                     withCompletionBlock: { (error, auth) in
                        if (error == nil) {
                            self.authenticationDelegate?.userAuthenticatedSuccess()
                            let UID = auth.uid
                            let userRef = self.usersRef.childByAppendingPath(UID)
                            userRef.observeEventType(.Value, withBlock: { (snapshot: FDataSnapshot!) in
                                self.user = User(snapshot: snapshot)
                            })
                        } else {
                            self.authenticationDelegate?.userAuthenticatedFail(error)
                        }
        })
    }

    private func setupListeners() {
        // post listening
        self.usersRef.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            // add child to array
            let user = User(snapshot: snapshot)
            self.users.append(user)
            // call delegate telling it something changed
        }

        self.usersRef.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) in
            // change child in array;
            let user = User(snapshot: snapshot)
            let index = self.users.indexOf(user)!
            self.users[index] = user
            // call delegate telling it something changed
        }

        self.usersRef.observeEventType(.ChildRemoved) { (snapshot: FDataSnapshot!) in
            // remove child from array
            let user = User(snapshot: snapshot)
            let index = self.users.indexOf(user)!
            self.users.removeAtIndex(index)
            // call delegate telling it something changed
        }

        // post listening
        self.postsRef.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in

        }

        self.postsRef.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) in

        }

        self.postsRef.observeEventType(.ChildRemoved) { (snapshot: FDataSnapshot!) in

        }
    }
}