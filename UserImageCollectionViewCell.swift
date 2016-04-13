//
//  UserImageCollectionViewCell.swift
//  Instagram
//
//  Created by Matthew Bracamonte on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class UserImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    var post: Post!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(post: Post) {
        self.post = post
        userImage.image = post.image
    }
    
}
