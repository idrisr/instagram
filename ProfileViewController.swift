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
    var userPosts = [Post]()
    let connectionController = ConnectionController.sharedConnection

    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfUsersFollowingLabel: UILabel!
    @IBOutlet weak var bioDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.connectionController.allPosts()
        self.connectionController.reloadUserPostsDelegate = self
        reloadCollectionView()
        numberOfPhotosLabel.text = "\(self.userPosts.count)\nPhotos"
        borderStyleForOutlets()
    }
    
    func saveBiography(controller: BiographyViewController, text: String) {
        bioDescriptionLabel.text = text
    }
    
    func reloadCollectionView() {
        self.userPosts = self.connectionController.posts
        self.collectionView.reloadData()
        print(userPosts)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserImageCell", forIndexPath: indexPath) as! UserImageCollectionViewCell
        let userImage: Post!
        userImage = userPosts[indexPath.row]
        cell.configureCell(userImage)
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
    


}
