//
//  PostListViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

//
//  This controller is in charge of the list of posts in a category
//


import UIKit

class PostListViewController: UITableViewController {
    
    var category = Dictionary<String, AnyObject>()
    var posts = [Dictionary<String, AnyObject>]?()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePostList()
    }
    
    func updatePostList() {
        WordPressWebServices.sharedInstance.posts(page:1, number: 100, completionHandler: { (posts, error) -> Void in
            if posts != nil {
                self.posts = posts
                dispatch_async(dispatch_get_main_queue(), { // access to UI in the main thread
                    self.tableView.reloadData()
                })
            }
        })
    }

    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let post = posts![indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = post
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            return posts!.count
        }
        else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Post", forIndexPath: indexPath) as! PostTableViewCell
        let post = posts![indexPath.row]
        cell.configureWithPostDictionary(post);
        return cell
    }
    
}


