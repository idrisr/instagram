//
//  CommentViewController.swift
//  Instagram
//
//  Created by dp on 4/13/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var enterCommentTextField: UITextField!
    
    @IBAction func onCommentButtonTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - TableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
        return cell
    }

}
