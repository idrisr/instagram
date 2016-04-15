//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Matthew Bracamonte on 4/12/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    ReloadPostsDelegate,
    UICollectionViewDelegateFlowLayout,
    AddBiographyControllerDelegate,
    LoggedInUserChangedDelegate,
    UserChangedDelegate {

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
    var loggedInUser: User!

    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        if profileUser == nil {
            self.profileUser = connectionController.getLoggedInUser()
        }

        self.navigationController?.navigationBarHidden = false

        collectionView.dataSource = self
        collectionView.delegate = self
        self.connectionController.reloadPostsDelegate = self
        self.connectionController.userChangedDelegate = self
        self.connectionController.loggedInUserChangedDelegate = self

        loggedInUserChangedSuccess()
        reloadPosts()
        configureFollowingViews()
        borderStyleForOutlets()
        userProfileInfo()
        checkUserBlogPost()
        
        numberOfPhotosLabel.text = "\(self.checkedPostArray.count)\nPhotos"
        

        numberOfPhotosLabel.text = "\(self.checkedPostArray.count)\nPhotos"
        bioDescriptionLabel.text = defaults.stringForKey("blog")
    }

    // does Fiaz consider this cheating?
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.profileUser = connectionController.getLoggedInUser()
    }

    func saveBiography(controller: BiographyViewController, text: String) {
        bioDescriptionLabel.text = text
    }
    
    func reloadPosts() {
        self.userPosts = self.connectionController.getAllPosts()
        checkedPostArray.removeAll()
        for post in userPosts {
            if post.uid == profileUser.uid {
                checkedPostArray.append(post)
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
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

    // dont use until VC exists and/or can escape from here
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "AddBioSegue" {
//            let destination = segue.destinationViewController as! BiographyViewController
//            destination.delegate = self
//        }
//    }

    func userProfileInfo() {
       usernameLbl.text = self.profileUser!.username
    }

    func checkUserBlogPost() {
        if defaults.objectForKey("blog") != nil {
            bioDescriptionLabel.text = defaults.stringForKey("blog")
        } else {
            bioDescriptionLabel.text = "Enter bio about yourself here"
        }
    }
    
    // MARK: UserChangedDelegate
    func userChangedSuccess() {
        // update logged in user information
        dispatch_async(dispatch_get_main_queue()) {
            self.profileUser = self.connectionController.getUserForUID(self.profileUser.uid)
            self.configureFollowingViews()
        }
    }

    // MARK: LoggedInUserDataChanged
    func loggedInUserChangedSuccess() {
        self.loggedInUser = connectionController.getLoggedInUser()
        self.configureFollowingViews()
    }


    // MARK: IBActions
    @IBAction func onToggleFollowButtonPressed(sender: AnyObject) {
        if self.loggedInUser.isFollowingUser(profileUser) {
            setUnFollow()
        } else {
            setFollow()
        }
        connectionController.saveUser(loggedInUser)
        connectionController.saveUser(profileUser)
    }

    // MARK: private functions
    private func setFollow() {
        loggedInUser.addFollowing(profileUser)
        profileUser.addFollower(loggedInUser)
    }

    private func setUnFollow() {
        loggedInUser.removeFollowing(profileUser)
        profileUser.removeFollower(loggedInUser)
    }

    private func configureFollowingViews() {
        // user not set or is logged in user
        if profileUser == loggedInUser {
            self.followButton.hidden = true
        } else {
            self.followButton.hidden = false
            if self.loggedInUser.isFollowingUser(profileUser) {
                self.followButton.setTitle("Unfollow", forState: .Normal)
            } else {
                self.followButton.setTitle("Follow", forState: .Normal)
            }
        }
        self.numberOfFollowersLabel.text = "\(self.profileUser.followerIDs.count)\n Followers"
        self.numberOfUsersFollowingLabel.text = "\(self.profileUser.followingIDs.count)\n Following"
    }
}
