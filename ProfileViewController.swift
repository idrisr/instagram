//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Matthew Bracamonte on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ReloadUserPostsDelegate,UICollectionViewDelegateFlowLayout, AddBiographyControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfUsersFollowingLabel: UILabel!
    @IBOutlet weak var bioDescriptionLabel: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followButton: UIButton!

    var userPosts = [Post]()
    var checkedPostArray = [Post]()
    let connectionController = ConnectionController.sharedConnection
    var profileUser: User!
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false

        // user not set or is logged in user
        if profileUser==nil || profileUser==self.connectionController.user {
            self.followButton.hidden = true
        } else {
            self.followButton.hidden = false
        }

        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.connectionController.allPosts()
        self.connectionController.reloadUserPostsDelegate = self
        
        reloadCollectionView()
        
        borderStyleForOutlets()
        userProfileInfo()
        checkIfUserPost()
        
        numberOfPhotosLabel.text = "\(self.checkedPostArray.count)\nPhotos"
        bioDescriptionLabel.text = defaults.stringForKey("blog")
        
    }
    
    func checkIfUserPost() {
        for post in userPosts {
            if post.uid == profileUser.uid {
                checkedPostArray.append(post)
            }
        }
    }
    
    func saveBiography(controller: BiographyViewController, text: String) {
        bioDescriptionLabel.text = text
    }
    
    func reloadCollectionView() {
        self.userPosts = self.connectionController.userPosts
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.checkedPostArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserImageCell", forIndexPath: indexPath) as! UserImageCollectionViewCell
        let userImage: Post!
        let user:User!
        user = profileUser
        userImage = checkedPostArray[indexPath.row]
        cell.configureCell(userImage, user: user)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(131, 131)
    }
    
    func borderStyleForOutlets() {
        numberOfPhotosLabel.layer.borderColor = UIColor.blueColor().CGColor
        numberOfPhotosLabel.layer.borderWidth = 1.0
        numberOfPhotosLabel.layer.cornerRadius = 5.0
        
        bioDescriptionLabel.layer.borderColor = UIColor.blueColor().CGColor
        bioDescriptionLabel.layer.borderWidth = 1.0
        bioDescriptionLabel.layer.cornerRadius = 5.0
        
        numberOfFollowersLabel.layer.borderColor = UIColor.blueColor().CGColor
        numberOfFollowersLabel.layer.borderWidth = 1.0
        numberOfFollowersLabel.layer.cornerRadius = 5.0
        
        numberOfUsersFollowingLabel.layer.borderColor = UIColor.blueColor().CGColor
        numberOfUsersFollowingLabel.layer.borderWidth = 1.0
        numberOfUsersFollowingLabel.layer.cornerRadius = 5.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddBioSegue" {
            let destination = segue.destinationViewController as! BiographyViewController
            destination.delegate = self
        }
    }
    
    func userProfileInfo() {
       usernameLbl.text = self.profileUser!.username
    }

    @IBAction func onToggleFollowButtonPressed(sender: AnyObject) {

    }
}

