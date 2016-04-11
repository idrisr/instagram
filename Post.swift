//
//  Post.swift
//  Instagram
//
//  Created by id on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import Firebase

struct Post {
    var image: UIImage
    var comments = [String]()
    var likes = 0
    var caption: String?
    let ref: Firebase?
    // var user: User

    // init from app
    // TODO

    // init from firebase
    init(snapshot: FDataSnapshot) {
        let data = NSData(base64EncodedString: snapshot.value["photo"] as! String, options: .IgnoreUnknownCharacters)
        image = UIImage(data: data!)!
        caption = snapshot.value["caption"] as! String?
        ref = snapshot.ref
    }

//    func toAnyObject() -> AnyObject {
//
//    }
}