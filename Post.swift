//
//  Post.swift
//  Instagram
//
//  Created by id on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

// Implement Equatable
func ==(lhs:Post, rhs:Post) -> Bool { // Implement Equatable
    return lhs.id == rhs.id
}

struct Post:Equatable {
    var image: UIImage
    var comments = [String]()
    var likes : [String]
    var caption: String
    let ref: Firebase?
    var id: String?
    var uid: String?

    static func image2String(image: UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.15);
        let imageString = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return imageString
    }

    static func string2Image(string: String) -> UIImage {
        let data = NSData(base64EncodedString: string, options: .IgnoreUnknownCharacters)
        return UIImage(data: data!)!
    }

    // init from firebase
    init(snapshot: FDataSnapshot) {
        let imageString = snapshot.value["image"] as! String
        self.image = Post.string2Image(imageString)
        self.caption = (snapshot.value["caption"] as! String?)!
        self.ref = snapshot.ref
        self.id = snapshot.key
        self.uid = snapshot.value["uid"] as! String?

        // set followingIDs
        if let likes = snapshot.value?["likes"] as? [String] {
            self.likes = likes
        } else {
            self.likes = []
        }

        // set comments
        if let comments = snapshot.value?["comments"] as? [String] {
            self.comments = comments
        } else {
            self.comments = []
        }
    }

    // init from device
    init(image: UIImage, caption: String, user: User) {
        self.image = image
        self.caption = caption
        self.ref = nil
        self.uid = user.uid
        self.likes = []
    }

    mutating func addLikeFromUser(user: User) {
        if !likes.contains(user.uid) {
            likes.append(user.uid)
        }
    }

    mutating func removeLikeFromUser(user: User) {
        if let index = likes.indexOf(user.uid) {
            likes.removeAtIndex(index)
        }
    }

    mutating func addComment(comment: String) {
        if !self.comments.contains(comment) {
            self.comments.append(comment)
        }
    }

    func toAnyObject() -> AnyObject {
        return [
            "image": Post.image2String(image),
            "comments": comments,
            "caption": caption,
            "uid": uid!,
            "likes": likes
        ]
    }
}