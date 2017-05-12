//
//  PostListViewController.swift
//  WordPress-API
//
//  Created by Pierre Marty on 11/02/2015.
//  Copyright (c) 2015 Pierre Marty. All rights reserved.
//

//
//  This controller is in charge of the list of posts
//


import UIKit

class PostListViewController: UITableViewController {
    
    var category = Dictionary<String, AnyObject>()
    var posts = [Dictionary<String, AnyObject>]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePostList()
    }
    
    func updatePostList() {
        WordPressWebServices.sharedInstance.lastPosts(page:1, number: 100, completionHandler: { (posts, error) -> Void in
            if posts != nil {
                self.posts = posts!
                DispatchQueue.main.async(execute: {     // access to UI in the main thread only !
                    self.tableView.reloadData()
                })
            }
        })
    }

    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let post = posts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = post
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configureWithPostDictionary(post);
        return cell
    }
    
}


