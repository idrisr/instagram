//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by dp on 4/13/16.
//  Copyright © 2016 id. All rights reserved.
//


import UIKit

protocol PostCellDelegate {
    func toggleLikeFromCell(cell: FeedTableViewCell)
}


class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellCaptionLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var userIDButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    var delegate: PostCellDelegate?

    @IBAction func onUserIDTapped(sender: AnyObject) {
    }
    
    @IBAction func onCommentFieldTapped(sender: AnyObject) {
    }
    
    @IBAction func onLikeButtonTapped(sender: AnyObject) {
        self.delegate?.toggleLikeFromCell(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}