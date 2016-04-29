//
//  SearchViewController.swift
//  Instagram
//
//  Created by dp on 4/13/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let connectionController = ConnectionController()
    
    var users = [User]()
    var searchBarIsSearching = false
    var filteredUsers = [User]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        users = connectionController.getAllUsers()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsSearching {
            return self.filteredUsers.count
        } else {
            return self.users.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        let user: User!
        
        if searchBarIsSearching {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.username
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchBarIsSearching = false
            tableView.reloadData()
            view.endEditing(true)
        } else {
            searchBarIsSearching = true
            let lower = searchBar.text!.lowercaseString
            filteredUsers = users.filter({$0.username?.rangeOfString(lower) != nil})
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchToProfileVC" {
            let destination = segue.destinationViewController as! ProfileViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let userToSend: User!
            
            if searchBarIsSearching {
                userToSend = filteredUsers[indexPath!.row]
            } else {
                userToSend = users[indexPath!.row]
            }
            let selectedUser = connectionController.getUserForUID(userToSend.uid)
            destination.profileUser = selectedUser
        }
    }

}
