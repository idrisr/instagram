//
//  TimelineViewController.swift
//  Instagram
//
//  Created by id on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadPostsDelegate {
    @IBOutlet weak var tableView: UITableView!
    let connectionController = ConnectionController.sharedConnection
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.connectionController.reloadPostsDelegate = self
        self.navigationController?.toolbar.hidden = false
        self.reloadPosts()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseID = "postCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath) as! FeedTableViewCell
        let post = self.posts[indexPath.row]

        let uid = post.uid!
        let user = connectionController.getUserForUID(uid)
        cell.userIDButton.setTitle(user?.username!, forState: .Normal)
        cell.cellImageView.image = post.image
        cell.cellCaptionLabel.text = post.caption
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 2
        return cell
    }

    // Mark: ReloadPostsDelegate
    func reloadPosts() {
        self.posts = self.connectionController.getAllPosts()
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let button = sender as! UIButton
        let cell = button.superview?.superview as! FeedTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let post = self.posts[indexPath!.row]
        let user = self.connectionController.getUserForUID(post.uid!)
        let destinvationVC = segue.destinationViewController as! ProfileViewController
        destinvationVC.profileUser = user
    }
}