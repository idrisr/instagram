//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by dp on 4/13/16.
//  Copyright © 2016 id. All rights reserved.
//


import UIKit


class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellCaptionLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var userIDButton: UIButton!
    
    @IBAction func onUserIDTapped(sender: AnyObject) {
    }
    
    @IBAction func onCommentFieldTapped(sender: AnyObject) {
    }
    
    @IBAction func onLikeButtonTapped(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}