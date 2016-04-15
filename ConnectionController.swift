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
    func reloadPosts()
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

protocol UserChangedDelegate {
    func userChangedSuccess()
}

protocol LoggedInUserChangedDelegate {
    func loggedInUserChangedSuccess()
}

class ConnectionController {

    var userPosts = [Post]()
    var reloadPostsDelegate: ReloadPostsDelegate?
    var createUserDelegate: UserCreationDelegate?
    var authenticationDelegate: AuthenticationDelegate?
    var userChangedDelegate: UserChangedDelegate?
    var loggedInUserChangedDelegate: LoggedInUserChangedDelegate?

    let ref = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/")
    let postsRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/posts")
    let usersRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/users")
    var loginUserRef: Firebase?

    static let sharedConnection = ConnectionController()

    private var users = [User]()
    private var posts = [Post]()
    private var user: User?

    init() {
        allUsers()
        allPosts()
        setupListeners()
    }

    func getLoggedInUser() -> User {
        return self.user!
    }

    func getAllUsers() -> [User] {
        return self.users
    }

    func getAllPosts() -> [Post] {
        return self.posts.reverse()
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
                // can do insert at 0 instead to keep most recent posts on top. O(n)?
                self.users.append(user)
            }
        }
    }

    // change to listener model and privatize
    // Dont need this because .ChildAdded listener will get called with all data on initial app start
    private func allPosts() {
        postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let post = Post(snapshot: item as! FDataSnapshot)
                if !self.posts.contains(post) {
                    self.posts.append(post)
                }
            }
        })
    }
    
    func savePost(post: Post) {
        // save post object
        var postRef: Firebase

        if post.ref == nil {
            postRef = self.postsRef.childByAutoId()
        } else {
            postRef = post.ref!
        }

        postRef.setValue(post.toAnyObject()) { (error: NSError!, ref: Firebase!) in
            if error == nil {
                self.user?.addPost(ref.key)
                let userRef = self.usersRef.childByAppendingPath(self.user?.uid)
                userRef.setValue(self.user?.toAnyObject())
            } else {
                print(error.localizedDescription)
            }
        }
    }

    func saveUser(user: User) {
        let userRef = self.usersRef.childByAppendingPath(user.uid)

        userRef.setValue(user.toAnyObject()) { (error: NSError!, ref: Firebase!) in
            if error == nil {
                self.userChangedDelegate?.userChangedSuccess()
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
                            print("logged in ok")
                            self.authenticationDelegate?.userAuthenticatedSuccess()
                            let UID = auth.uid

                            let userRef = self.usersRef.childByAppendingPath(UID)
                            userRef.observeEventType(.Value, withBlock: { (snapshot: FDataSnapshot!) in
                                self.user = User(snapshot: snapshot)
                                self.loggedInUserChangedDelegate?.loggedInUserChangedSuccess()
                            })
                        } else {
                            self.authenticationDelegate?.userAuthenticatedFail(error)
                        }
        })
    }

    private func setupListeners() {
        // user listening
        self.usersRef.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            // add child to array
            let user = User(snapshot: snapshot)
            if !self.users.contains(user) {
                self.users.append(user)
            }
            self.userChangedDelegate?.userChangedSuccess()
        }

        self.usersRef.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) in
            // change child in array;
            let user = User(snapshot: snapshot)
            let index = self.users.indexOf(user)!
            self.users[index] = user
            self.userChangedDelegate?.userChangedSuccess()
        }

        self.usersRef.observeEventType(.ChildRemoved) { (snapshot: FDataSnapshot!) in
            // remove child from array
            let user = User(snapshot: snapshot)
            let index = self.users.indexOf(user)!
            self.users.removeAtIndex(index)
            self.userChangedDelegate?.userChangedSuccess()
        }

        // post listening
        self.postsRef.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            let post = Post(snapshot: snapshot)
            if !self.posts.contains(post) {
                self.posts.append(post)
            }
            self.reloadPostsDelegate?.reloadPosts()
        }

        self.postsRef.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) in
            let post = Post(snapshot: snapshot)
            let index = self.posts.indexOf(post)
            self.posts[index!] = post
            self.reloadPostsDelegate?.reloadPosts()
        }

        self.postsRef.observeEventType(.ChildRemoved) { (snapshot: FDataSnapshot!) in
            // remove child from array
            let post = Post(snapshot: snapshot)
            let index = self.posts.indexOf(post)!
            self.posts.removeAtIndex(index)
            self.reloadPostsDelegate?.reloadPosts()
        }
    }
}