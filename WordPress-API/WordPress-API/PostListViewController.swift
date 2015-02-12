//
//  PostListViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

//
//  This controller is in charge of the list post tagged with a category
//


import UIKit

class PostListViewController: UITableViewController {
    
    var category = Dictionary<String, AnyObject>()
    let webService = WordPressWebServices()
    var posts = [Dictionary<String, AnyObject>]()
    var detailViewController: DetailViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        self.updatePostList()
    }
    
    func updatePostList() {
        webService.postsInCategory(category["slug"] as! String, completionHandler: { (posts, error) -> Void in
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
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let post = posts[indexPath.row]
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
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Post", forIndexPath: indexPath) as! UITableViewCell
        
        let category = posts[indexPath.row]
        cell.textLabel!.text = category["title"] as? String
        return cell
    }
    
    
}
