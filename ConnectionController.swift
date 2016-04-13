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


// TODO: handle post deletion

class ConnectionController {
    let ref = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/")
    let postRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/posts")
    let userRef = Firebase(url: "https://glowing-inferno-2878.firebaseio.com/users")
    var posts = [Post]()
    var userPosts = [Post]()

    var reloadPostsDelegate: ReloadPostsDelegate?
    var reloadUserPostsDelegate: ReloadUserPostsDelegate?

    static let sharedConnection = ConnectionController()

    func allPosts() {
        postRef.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let post = Post(snapshot: item as! FDataSnapshot)
                if !self.posts.contains(post) {
                    self.posts.append(post)
                    self.userPosts.append(post)
                }
            }
            self.reloadPostsDelegate?.reloadModel()
            self.reloadUserPostsDelegate?.reloadCollectionView()
            
        })
    }

    func savePost(post: Post) {
        let childRef = self.postRef.childByAutoId()
        childRef.setValue(post.toAnyObject())
    }
}