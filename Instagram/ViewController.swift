//
//  ViewController.swift
//  Instagram
//
//  Created by id on 4/11/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadPostsDelegate {
    @IBOutlet weak var tableView: UITableView!
    let connectionController = ConnectionController.sharedConnection
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.connectionController.allPosts()
        self.connectionController.reloadPostsDelegate = self
        self.navigationController?.toolbar.hidden = false
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseID = "postCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID, forIndexPath: indexPath)
        let post = self.posts[indexPath.row]
        cell.textLabel!.text = post.caption
        cell.imageView!.image = post.image
        return cell
    }

    // Mark: ReloadPostsDelegate
    func reloadModel() {
        self.posts = self.connectionController.posts
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}