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
//    var comments = [String]()
    var likes = 0
    var caption: String
    let ref: Firebase?
    // var user: User

    static func image2String(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image);
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
        image = Post.string2Image(imageString)
        caption = (snapshot.value["caption"] as! String?)!
        ref = snapshot.ref
    }

    // init from device
    init(image: UIImage) {
        self.image = image
        caption = "to do"
        ref = nil
    }

    func description() -> String {
        return "\(self.caption)"
    }

    func toAnyObject() -> AnyObject {
        return [
            "image": Post.image2String(image),
            "comments": "",
            "caption": caption
        ]
    }
}